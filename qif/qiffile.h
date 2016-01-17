#ifndef QIFFILE_H
#define QIFFILE_H

#include <QObject>
#include <QUrl>
#include <QStringList>
#include "myfile.h"
#include <QTextCodec>

#include "transaction.h"

#include <QDebug>

class QifFile : public QObject
{
    Q_OBJECT

public:
    explicit QifFile(QObject *parent = 0);
    ~QifFile();

    bool read(QUrl filename);
    void save(QUrl filename);

    QString type()  const { return typeQif; }    // Return type of data
    int size()      const { return l_transactions.size(); }

    Transaction *transaction(int index);

    void setCodecName(const QString &name) { m_codecName = name; }

signals:

public slots:

private:
    char separator_entry;   // character separating two transactions
    QStringList l_type;     // valid types
    QString typeQif;
    QList<Transaction*> l_transactions;
    QString m_codecName;
};

#endif // QIFFILE_H
