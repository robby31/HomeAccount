#include "qiffile.h"

QifFile::QifFile(QObject *parent) :
    QObject(parent),
    separator_entry('^'),
    typeQif(),
    m_codecName()
{
    DebugInfo::add_object(this);
    l_type << "Cash" << "Bank" << "CCard" << "Invst" << "Oth A" << "Oth L";
}

QifFile::~QifFile()
{
    DebugInfo::remove_object(this);
    qDeleteAll(l_transactions);
}

bool QifFile::read(const QUrl &filename)
{
    MyFile tmp(filename.toLocalFile());

    if (!tmp.open())
    {
        return false;
    }

    tmp.setCodecName(m_codecName);

    // read the QIF type
    typeQif = tmp.readLine().trimmed();
    if (!typeQif.startsWith("!Type:") && !typeQif.startsWith("!type:"))
    {
        qCritical() << "class" << metaObject()->className() << "type is invalid" << typeQif;
        return false;
    }

    typeQif = typeQif.right(typeQif.size()-6);

    if (!l_type.contains(typeQif))
    {
        qCritical() << "class" << metaObject()->className()  << "type is invalid" << typeQif;
        return false;
    }

    // read data
    foreach (QString entry, tmp.readAll().split(separator_entry))
    {
        QifTransaction *transaction = new QifTransaction(entry.trimmed().split('\n'), this);
        if (transaction->isValid())
            l_transactions.append(transaction);
        else
            delete transaction;
    }

    tmp.close();

    return true;
}

Transaction *QifFile::transaction(int index)
{
    if (index >= 0 && index < l_transactions.size())
        return l_transactions.at(index);

    return Q_NULLPTR;
}

