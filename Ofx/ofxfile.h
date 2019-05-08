#ifndef OFXFILE_H
#define OFXFILE_H

#include <QObject>
#include <QUrl>
#include "../common/transaction.h"
#include "../common/myfile.h"
#include "Document/markupdocument.h"

class OfxFile : public QObject
{
    Q_OBJECT

public:
    explicit OfxFile(QObject *parent = nullptr);

    bool read(const QUrl &filename);

    int size() const;

    Transaction *transaction(const int &index);

private:
    QList<MarkupBlock*> transactions() const;

    QVariant transactionAttribute(MarkupBlock *transaction, const QString &param);

signals:

public slots:

private:
    QStringList m_header;
    MarkupDocument m_doc;
    QHash<int, Transaction*> m_transactions;
};

#endif // OFXFILE_H
