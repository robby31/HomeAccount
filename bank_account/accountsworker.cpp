#include "accountsworker.h"

AccountsWorker::AccountsWorker(QObject *parent):
    Worker(parent)
{
    connect(this, SIGNAL(initializeWorkerSignal()), this, SLOT(_initializeWorker()));
}

AccountsWorker::~AccountsWorker()
{
    QSqlDatabase db = GET_DATABASE("ACCOUNTS");

    if (db.isOpen())
        db.close();
}

void AccountsWorker::initializeWorker()
{
    emit initializeWorkerSignal();
}

void AccountsWorker::_initializeWorker()
{
    CREATE_DATABASE("QSQLITE", "ACCOUNTS");
}

bool AccountsWorker::initializeDatabase()
{
    // create all tables if necessary
    QSqlQuery query(GET_DATABASE("ACCOUNTS"));

    if (!query.exec("create table IF NOT EXISTS accounts "
                    "(id INTEGER primary key, "
                    "name UNIQUE, "
                    "number INTEGER UNIQUE NOT NULL)"))
        return false;

    if (!query.exec("create table IF NOT EXISTS transactions "
                    "(id INTEGER primary key, "
                    "number DEFAULT '', "
                    "account_id INTEGER NOT NULL, "
                    "is_split INTEGER DEFAULT 0, "
                    "split_id INTEGER DEFAULT 0, "
                    "date DATE DEFAULT CURRENT_DATE, "
                    "amount REAL DEFAULT 0.0, "
                    "status, "
                    "payee DEFAULT '', "
                    "category DEFAULT '', "
                    "memo DEFAULT '', "
                    "UNIQUE(account_id, split_id, date, payee, amount))"))
        return false;

    return true;
}

void AccountsWorker::loadDatabase(const QString &fileUrl)
{
    emit processStarted();

    QSqlDatabase db = GET_DATABASE("ACCOUNTS");

    if (db.isOpen())
        db.close();

    QString filename = QUrl::fromUserInput(fileUrl).toLocalFile();
    db.setDatabaseName(QDir::toNativeSeparators(filename));

    if (db.open())
    {
        if  (initializeDatabase())
        {
            emit processOver("Loading done.");
            emit databaseOpenedSignal(fileUrl);
        }
        else
        {
            emit errorDuringProcess("unable to create table transactions.");
            db.close();
        }
    }
    else
    {
        emit errorDuringProcess(QString("unable to open database %1").arg(filename));
    }
}

void AccountsWorker::closeDatabase()
{
    emit processStarted();

    QSqlDatabase db = GET_DATABASE("ACCOUNTS");

    db.close();

    emit databaseClosedSignal();

    emit processOver();
}

void AccountsWorker::importQif(const int &idAccount, const QString &fileUrl)
{
    emit processStarted();

    QifFile qif;
    if (!qif.read(QUrl::fromUserInput(fileUrl)))
    {
        emit errorDuringProcess("unable to load "+fileUrl);
    }
    else
    {
        int transactionsLoaded = 0;

        QSqlQuery query(GET_DATABASE("ACCOUNTS"));

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
                qWarning() << "error" << index << query.lastError();
            }
            else
            {
                ++transactionsLoaded;
            }
        }

        emit processOver(QString("%1 transactions loaded.").arg(transactionsLoaded));
        emit transactionsUpdatedSignal();
    }
}

void AccountsWorker::create_account(const QString &name, const QString &number)
{
    emit processStarted();

    QSqlQuery query(GET_DATABASE("ACCOUNTS"));

    query.prepare("INSERT INTO accounts (name, number) "
                  "VALUES (:name, :number)");

    query.bindValue(":name", name);
    query.bindValue(":number", number);

    if (query.exec())
    {
        emit processOver(QString("Account %1 (%2) created.").arg(name).arg(number));
        emit accountsUpdatedSignal();
    }
    else
    {
        emit errorDuringProcess(query.lastError().text());
    }
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
