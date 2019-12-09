#include "qiftransaction.h"

QifTransaction::QifTransaction(const QStringList &data, QObject *parent) :
    Transaction(parent),
    m_dateRegExp(R"(^(\d+)/(\d+)['/](\d+))")
{
    foreach(QString elt, data)
    {
        QString tmp = elt.trimmed();
        if (tmp.size() > 0)
        {
            if (tmp[0] == 'D')
            {
                QString date = tmp.right(tmp.size()-1);
                if (m_dateRegExp.indexIn(date) != -1)
                {
                    QDate date = QDate::fromString(QString("%1/%2/%3").arg(m_dateRegExp.cap(1), m_dateRegExp.cap(2), m_dateRegExp.cap(3)), "d/M/yyyy");
                    if (date.isValid())
                    {
                        setValid(true);
                        setDate(date);
                    }
                    else
                    {
                        qDebug() << "class" << metaObject()->className() << ": INVALID date" << tmp;
                    }
                }
                else
                {
                    qDebug() << "class" << metaObject()->className() << ": INVALID date" << tmp;
                }
            }
            else if (tmp[0] == 'T')
            {
                setValid(true);
                double amount = QVariant::fromValue(tmp.right(tmp.size()-1).replace(',', "")).toDouble();
                setAmount(QVariant::fromValue(amount).toString());
            }
            else if (tmp[0] == 'M')
            {
                setValid(true);
                setMemo(tmp.right(tmp.size()-1));
            }
            else if (tmp[0] == 'P')
            {
                setValid(true);
                setPayee(tmp.right(tmp.size()-1));
            }
            else if (tmp[0] == 'L')
            {
                setValid(true);
                setCategory(tmp.right(tmp.size()-1));
            }
            else if (tmp[0] == 'C')
            {
                if (tmp == "C*" ||  tmp == "Cc")
                {
                    setValid(true);
                    setStatus("cleared");
                }
                else if (tmp == "CX" || tmp == "CR")
                {
                    setValid(true);
                    setStatus("reconciled");
                }
                else if (tmp == "C" || tmp == "C ")
                {
                    setValid(true);
                    setStatus("not cleared");
                }
                else
                {
                    qDebug() << "class" << metaObject()->className() << ": INVALID status" << tmp;
                }
            }
            else if (tmp[0] == 'N')
            {
                setValid(true);
                setNumber(tmp.right(tmp.size()-1));
            }
            else if (tmp[0] == 'A')
            {
                setValid(true);
                setAddressPayee(tmp.right(tmp.size()-1));
            }
            else
            {
                qDebug() << "class" << metaObject()->className() << ": INVALID data" << tmp;
            }
        }
    }
}
