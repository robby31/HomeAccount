#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include "SqlModel/sqltablemodel.h"

class AccountsModel : public SqlTableModel
{
    Q_OBJECT

public:
    explicit AccountsModel(QObject *parent = Q_NULLPTR);

public slots:
    void createAccount(const QString &name, const QString &number);

};

#endif // ACCOUNTSMODEL_H
