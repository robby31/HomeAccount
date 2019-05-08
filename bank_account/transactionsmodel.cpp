#include "transactionsmodel.h"

TransactionsModel::TransactionsModel(QObject *parent):
    SqlTableModel("ACCOUNTS", parent)
{
    setEditStrategy(OnFieldChange);
    setTable("transactions");
}

QVariant TransactionsModel::data(const QModelIndex &item, int role) const
{
    if (item.isValid() && role == Qt::DisplayRole)
    {
        QSqlRecord tmp = record(item.row());
        if (!tmp.isEmpty())
        {
            QSqlField field = tmp.field(item.column());
            if (field.tableName() == "transactions" && field.name() == "date")
            {
                QDateTime date = QDateTime::fromString(field.value().toString(), "yyyy-MM-dd");
                if (date.isValid())
                    return date;
            }
            else if (field.name() == "month")
            {
                QDateTime date = QDateTime::fromString(field.value().toString(), "yyyy-MM-dd");
                if (date.isValid())
                    return date;
            }
        }
    }

    return SqlTableModel::data(item, role);
}

void TransactionsModel::importQif(const int &idAccount, const QString &fileUrl)
{
    QifFile qif;
    if (!qif.read(QUrl::fromUserInput(fileUrl)))
    {
        qCritical() << "unable to load" << fileUrl;
    }
    else
    {
        int transactionsLoaded = 0;

        QSqlQuery query(database());

        query.prepare("INSERT INTO transactions (account_id, date, amount, payee, memo, status, category) "
                      "VALUES (:account_id, :date, :amount, :payee, :memo, :status, :category)");
        query.bindValue(":account_id", idAccount);

        for (int index=0; index<qif.size(); ++index)
        {
            Transaction *transaction = qif.transaction(index);
            query.bindValue(":date", transaction->date());
            query.bindValue(":amount", transaction->amount());
            query.bindValue(":payee", transaction->payee());
            query.bindValue(":memo", transaction->memo());
            query.bindValue(":status", transaction->status());
            query.bindValue(":category", transaction->category());

            if (!query.exec())
            {
                qCritical() << "error" << index << query.lastError();
            }
            else
            {
                ++transactionsLoaded;
            }
        }

        qInfo() << transactionsLoaded << "transactions loaded.";
        select();
    }
}

void TransactionsModel::create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount)
{
    QSqlQuery query(database());

    query.prepare("INSERT INTO transactions (account_id, date, payee, memo, amount) "
                  "VALUES (:account_id, :date, :payee, :memo, :amount)");

    query.bindValue(":account_id", idAccount);
    query.bindValue(":date", QVariant::fromValue(QVariant::fromValue(date).toDate()));
    query.bindValue(":payee", payee);
    query.bindValue(":memo", memo);
    query.bindValue(":amount", amount);

    if (query.exec())
    {
        select();
    }
    else
    {
        qCritical() << "unable to create transaction" << query.lastError().text();
    }
}

void TransactionsModel::create_split_transaction(const int &idAccount, const int &idTransaction, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount)
{
    QSqlDatabase db = database();

    if (db.isValid())
    {
        QSqlQuery query(db);

        if (db.transaction())
        {
            query.prepare("INSERT INTO transactions (account_id, split_id, date, payee, memo, amount) "
                          "VALUES (:account_id, :split_id, :date, :payee, :memo, :amount)");

            query.bindValue(":account_id", idAccount);
            query.bindValue(":split_id", idTransaction);
            query.bindValue(":date", QVariant::fromValue(QVariant::fromValue(date).toDate()));
            query.bindValue(":payee", payee);
            query.bindValue(":memo", memo);
            query.bindValue(":amount", amount);

            if (query.exec())
            {
                query.prepare("UPDATE transactions SET is_split='1' WHERE id=:id");
                query.bindValue(":id", idTransaction);

                if (query.exec())
                {
                    if (db.commit())
                    {
                        select();
                    }
                    else
                    {
                        db.rollback();
                        qCritical() << "unable to commit transaction" << db.lastError().text();
                    }
                }
                else
                {
                    db.rollback();
                    qCritical() << "unable to update transaction" << db.lastError().text();
                }
            }
            else
            {
                db.rollback();
                qCritical() << "unable to create transaction" << db.lastError().text();
            }
        }
        else
        {
            qCritical() << "unable to start commit" << db.lastError().text();
        }
    }
    else
    {
        qCritical() << "invalid database";
    }
}

void TransactionsModel::check_split_id(const int &transactionId)
{
    QSqlQuery query(database());

    query.prepare("SELECT count(id) from transactions WHERE split_id=:split_id");
    query.bindValue(":split_id", transactionId);

    if (!query.exec())
    {
        qCritical() << "invalid query" << query.lastError().text();
    }
    else
    {
        if (query.next() && query.value(0).toInt() == 0)
        {
            // no more transaction related to transactionId
            // so transactionId is not split any more
            query.prepare("UPDATE transactions SET is_split=0 WHERE id=:id");
            query.bindValue(":id", transactionId);
            if (!query.exec())
                qCritical() << "unable to update transaction" << query.lastError().text();
        }
    }
}

void TransactionsModel::importOfx(const int &idAccount, const QString &fileUrl)
{
    OfxFile ofx;
    if (!ofx.read(QUrl::fromUserInput(fileUrl)))
    {
        qCritical() << "unable to load" << fileUrl;
    }
    else
    {
        int transactionsLoaded = 0;

        QSqlQuery query(database());

        query.prepare("INSERT INTO transactions (account_id, date, amount, payee, memo, status, category) "
                      "VALUES (:account_id, :date, :amount, :payee, :memo, :status, :category)");
        query.bindValue(":account_id", idAccount);

        for (int index=0; index<ofx.size(); ++index)
        {
            Transaction *transaction = ofx.transaction(index);

            if (transaction->isValid())
            {
                query.bindValue(":date", transaction->date());
                query.bindValue(":amount", transaction->amount());
                query.bindValue(":payee", transaction->payee());
                query.bindValue(":memo", transaction->memo());

                if (!query.exec())
                {
                    qCritical() << "error" << index << query.lastError();
                }
                else
                {
                    ++transactionsLoaded;
                }
            }
            else
            {
                qCritical() << "invalid transaction" << index;
            }
        }

        qInfo() << transactionsLoaded << "transactions loaded.";
        select();
    }
}
