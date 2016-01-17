#include "transaction.h"

Transaction::Transaction(QStringList data, QObject *parent) :
    QObject(parent),
    m_valid(false),
    m_date(),
    m_dateRegExp("^(\\d+)/(\\d+)['/](\\d+)"),
    m_amount(),
    m_memo(),
    m_payee(),
    m_category(),
    m_status(),
    m_number(),
    m_addressPayee()
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
                    m_date = QDate::fromString(QString("%1/%2/%3").arg(m_dateRegExp.cap(1)).arg(m_dateRegExp.cap(2)).arg(m_dateRegExp.cap(3)), "d/M/yyyy");
                    if (m_date.isValid())
                        m_valid = true;
                    else
                       qDebug() << "class" << metaObject()->className() << ": INVALID date" << tmp;
                }
                else
                {
                    qDebug() << "class" << metaObject()->className() << ": INVALID date" << tmp;
                }
            }
            else if (tmp[0] == 'T')
            {
                m_valid = true;
                double amount = QVariant::fromValue(tmp.right(tmp.size()-1).replace(',', "")).toDouble();
                m_amount = QVariant::fromValue(amount).toString();
            }
            else if (tmp[0] == 'M')
            {
                m_valid = true;
                m_memo = tmp.right(tmp.size()-1);
            }
            else if (tmp[0] == 'P')
            {
                m_valid = true;
                m_payee = tmp.right(tmp.size()-1);
            }
            else if (tmp[0] == 'L')
            {
                m_valid = true;
                m_category = tmp.right(tmp.size()-1);
            }
            else if (tmp[0] == 'C')
            {
                if (tmp == "C*" or  tmp == "Cc")
                {
                    m_valid = true;
                    m_status = "cleared";
                }
                else if (tmp == "CX" or tmp == "CR")
                {
                    m_valid = true;
                    m_status = "reconciled";
                }
                else if (tmp == "C" or tmp == "C ")
                {
                    m_valid = true;
                    m_status = "not cleared";
                }
                else
                {
                    qDebug() << "class" << metaObject()->className() << ": INVALID status" << tmp;
                }
            }
            else if (tmp[0] == 'N')
            {
                m_valid = true;
                m_number = tmp.right(tmp.size()-1);
            }
            else if (tmp[0] == 'A')
            {
                m_valid = true;
                m_addressPayee = tmp.right(tmp.size()-1);
            }
            else
            {
                qDebug() << "class" << metaObject()->className() << ": INVALID data" << tmp;
            }
        }
    }
}

Transaction::~Transaction()
{

}

