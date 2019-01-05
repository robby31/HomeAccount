#ifndef TRANSACTIONSMODEL_H
#define TRANSACTIONSMODEL_H

#include "SqlModel/sqlquerymodel.h"

class TransactionsModel : public SqlQueryModel
{
    Q_OBJECT

public:
    explicit TransactionsModel(QObject *parent = Q_NULLPTR);

    QVariant data(const QModelIndex &item, int role = Qt::DisplayRole) const Q_DECL_OVERRIDE;

};

#endif // TRANSACTIONSMODEL_H
