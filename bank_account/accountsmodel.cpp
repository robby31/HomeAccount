#include "accountsmodel.h"

AccountsModel::AccountsModel(QObject *parent):
    SqlTableModel("ACCOUNTS", parent)
{
    setTable("accounts");
}

void AccountsModel::createAccount(const QString &name, const QString &number)
{
    QSqlQuery tmpQuery(database());

    tmpQuery.prepare("INSERT INTO accounts (name, number) "
                     "VALUES (:name, :number)");

    tmpQuery.bindValue(":name", name);
    tmpQuery.bindValue(":number", number);

    if (tmpQuery.exec())
    {
        select();
    }
    else
    {
        qCritical() << "unable to create account" << name << number;
    }
}
