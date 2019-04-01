#include "accountscontroller.h"

AccountsController::AccountsController(QObject *parent):
    Controller(parent)
{
}

bool AccountsController::initializeDatabase()
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
