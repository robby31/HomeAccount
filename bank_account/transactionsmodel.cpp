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
