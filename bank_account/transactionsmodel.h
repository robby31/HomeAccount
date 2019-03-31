#ifndef TRANSACTIONSMODEL_H
#define TRANSACTIONSMODEL_H

#include "SqlModel/sqltablemodel.h"
#include "../qif/qiffile.h"

class TransactionsModel : public SqlTableModel
{
    Q_OBJECT

public:
    explicit TransactionsModel(QObject *parent = Q_NULLPTR);

    QVariant data(const QModelIndex &item, int role = Qt::DisplayRole) const Q_DECL_OVERRIDE;

public slots:
    void importQif(const int &idAccount, const QString &fileUrl);

};

#endif // TRANSACTIONSMODEL_H
