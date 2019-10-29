#include "ofxfile.h"

OfxFile::OfxFile(QObject *parent) : QObject(parent)
{
    DebugInfo::add_object(this);

    QStringList tags;
    tags << "ACCTID" << "ACCTTYPE" << "ACCTKEY" << "BALAMT" << "BANKID" << "BRANCHID"
         << "CODE" << "CURDEF" << "DTASOF" << "DTSERVER" << "DTSTART" << "DTEND" << "DTPOSTED" << "FITID" << "LANGUAGE" << "MEMO" << "NAME" << "SEVERITY"
         << "TRNUID" << "TRNTYPE" << "TRNAMT";
    m_doc.setSingletonTag(tags);
}

OfxFile::~OfxFile()
{
    DebugInfo::remove_object(this);
}

QList<MarkupBlock*> OfxFile::transactions() const
{
    return m_doc.firstBlock()->findBlocks("STMTTRN");
}

int OfxFile::size() const
{
    return transactions().size();
}

bool OfxFile::read(const QUrl &filename)
{
    qDeleteAll(m_transactions.values());
    m_transactions.clear();

    MyFile tmp(filename.toLocalFile());

    if (!tmp.open())
        return false;

    QString header = tmp.readLine().trimmed();
    while (!header.startsWith("<OFX>"))
    {
        if (!header.isEmpty())
            m_header << header;
        header = tmp.readLine().trimmed();
    }

    m_doc.setContent("<OFX>"+tmp.readAll());

    tmp.close();

    return true;
}

QVariant OfxFile::transactionAttribute(MarkupBlock *transaction, const QString &param)
{
    MarkupBlock *paramBlock = transaction->findBlock(param);
    if (paramBlock && paramBlock->blocks().size() == 1)
    {
        QString data = paramBlock->blocks().at(0)->toString();
        return data;
    }

    return QVariant();
}

Transaction *OfxFile::transaction(const int &index)
{
    QList<MarkupBlock*> l_transactions = transactions();
    if (index >=0 && index < l_transactions.size())
    {
        if (m_transactions.contains(index))
            return m_transactions[index];

        auto tr = new Transaction(this);

        MarkupBlock *block = l_transactions.at(index);
        tr->setPayee(transactionAttribute(block, "NAME").toString());
        tr->setMemo(transactionAttribute(block, "MEMO").toString());
        tr->setAmount(transactionAttribute(block, "TRNAMT").toString());

        QDate date = QDate::fromString(transactionAttribute(block, "DTPOSTED").toString().left(8), "yyyyMMdd");
        if (date.isValid())
            tr->setDate(date);

        if (tr->date().isValid() && !tr->memo().isEmpty() && !tr->amount().isEmpty())
            tr->setValid(true);

//        qWarning() << "ID" << transactionAttribute(block, "FITID");
//        qWarning() << "TYPE" << transactionAttribute(block, "TRNTYPE");
//        qWarning() << "DATE" << transactionAttribute(block, "DTPOSTED");
//        qWarning() << "NAME" << transactionAttribute(block, "NAME");
//        qWarning() << "MEMO" << transactionAttribute(block, "MEMO");
//        qWarning() << "AMOUNT" << transactionAttribute(block, "TRNAMT");

        m_transactions[index] = tr;

        return tr;
    }

    return Q_NULLPTR;
}
