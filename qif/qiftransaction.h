#ifndef QIFTRANSACTION_H
#define QIFTRANSACTION_H

#include "../common/transaction.h"

class QifTransaction : public Transaction
{

public:
    explicit QifTransaction(const QStringList &data, QObject *parent = Q_NULLPTR);

private:
    QRegExp m_dateRegExp;
};

#endif // QIFTRANSACTION_H
