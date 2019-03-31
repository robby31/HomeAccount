#include "accountsworker.h"

AccountsWorker::AccountsWorker(QObject *parent):
    Worker(parent)
{
}

void AccountsWorker::create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount)
{
    emit processStarted();

    QSqlQuery query(GET_DATABASE("ACCOUNTS"));

    query.prepare("INSERT INTO transactions (account_id, date, payee, memo, amount) "
                  "VALUES (:account_id, :date, :payee, :memo, :amount)");

    query.bindValue(":account_id", idAccount);
    query.bindValue(":date", QVariant::fromValue(QVariant::fromValue(date).toDate()));
    query.bindValue(":payee", payee);
    query.bindValue(":memo", memo);
    query.bindValue(":amount", amount);

    if (query.exec())
    {
        emit processOver(QString("Transaction created."));
        emit transactionsUpdatedSignal();
    }
    else
    {
        emit errorDuringProcess(query.lastError().text());
    }
}

void AccountsWorker::create_split_transaction(const int &idAccount, const int &idTransaction, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount)
{
    emit processStarted();

    QSqlDatabase db = GET_DATABASE("ACCOUNTS");

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
                        emit processOver(QString("Transaction created."));
                        emit transactionsUpdatedSignal();
                    }
                    else
                    {
                        db.rollback();
                        qCritical() << db.lastError().text();
                        emit errorDuringProcess("unable to commit transaction");
                    }
                }
                else
                {
                    db.rollback();
                    emit errorDuringProcess(query.lastError().text());
                }
            }
            else
            {
                db.rollback();
                emit errorDuringProcess(query.lastError().text());
            }
        }
        else
        {
            emit errorDuringProcess("unable to start transaction");
        }
    }
    else
    {
        emit errorDuringProcess("invalid database");
    }
}

