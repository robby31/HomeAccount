#include "qiffile.h"

QifFile::QifFile(QObject *parent) :
    QObject(parent),
    separator_entry('^'),
    l_type(),
    typeQif(),
    m_codecName()
{
    l_type << "Cash" << "Bank" << "CCard" << "Invst" << "Oth A" << "Oth L";
}

QifFile::~QifFile()
{

}

bool QifFile::read(QUrl filename)
{
    MyFile tmp(filename.toLocalFile());

    if (!tmp.open())
    {
        return false;
    }
    else
    {
        tmp.setCodecName(m_codecName);

        // read the QIF type
        typeQif = tmp.readLine().trimmed();
        if (!typeQif.startsWith("!Type:") && !typeQif.startsWith("!type:"))
        {
            qCritical() << "class" << metaObject()->className() << "type is invalid" << typeQif;
            return false;
        }
        else
        {
            typeQif = typeQif.right(typeQif.size()-6);
        }

        if (!l_type.contains(typeQif))
        {
            qCritical() << "class" << metaObject()->className()  << "type is invalid" << typeQif;
            return false;
        }

        // read data
        foreach (QString entry, tmp.readAll().split(separator_entry))
        {
            Transaction *transaction = new Transaction(entry.trimmed().split('\n'));
            if (transaction->isValid())
                l_transactions.append(transaction);
            else
                delete transaction;
        }

        tmp.close();

        return true;
    }
}

Transaction *QifFile::transaction(int index)
{
    if (index < l_transactions.size())
        return l_transactions.at(index);

    return 0;
}

