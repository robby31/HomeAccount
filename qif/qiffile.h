#ifndef QIFFILE_H
#define QIFFILE_H

#include <QObject>
#include <QUrl>
#include <QStringList>
#include "../common/myfile.h"
#include <QTextCodec>

#include "qiftransaction.h"

#include <QDebug>

class QifFile : public QObject
{
    Q_OBJECT

public:
    explicit QifFile(QObject *parent = Q_NULLPTR);

    bool read(const QUrl &filename);
    void save(QUrl filename);

    QString type()  const;   // Return type of data
    int size()      const;

    Transaction *transaction(int index);

    void setCodecName(const QString &name);

private:
    char separator_entry = '^';   // character separating two transactions
    QStringList l_type;           // valid types
    QString typeQif;
    QList<Transaction*> l_transactions;
    QString m_codecName;
};

#endif // QIFFILE_H
