#include "transaction.h"

Transaction::Transaction(QObject *parent) :
    QObject(parent)
{

}

void Transaction::setValid(const bool &flag)
{
    m_valid = flag;
}

void Transaction::setDate(const QDate &date)
{
    m_date = date;
}

void Transaction::setPayee(const QString &payee)
{
    m_payee = payee;
}

void Transaction::setMemo(const QString &memo)
{
    m_memo = memo;
}

void Transaction::setAmount(const QString &amount)
{
    m_amount = amount;
}

void Transaction::setCategory(const QString &category)
{
    m_category = category;
}

void Transaction::setStatus(const QString &status)
{
    m_status = status;
}

void Transaction::setNumber(const QString &number)
{
    m_number = number;
}

void Transaction::setAddressPayee(const QString &addresPayee)
{
    m_addressPayee = addresPayee;
}
