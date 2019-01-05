#include "transactionsmodel.h"

TransactionsModel::TransactionsModel(QObject *parent):
    SqlQueryModel(parent)
{

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

    return QSqlQueryModel::data(item, role);
}
