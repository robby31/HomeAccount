#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QObject>
#include <QHash>
#include <QRegExp>
#include <QDate>

#include <QDebug>

class Transaction : public QObject
{
    Q_OBJECT

public:
    explicit Transaction(QStringList data, QObject *parent = 0);
    virtual ~Transaction();

    bool isValid()      const { return m_valid; }

    QDate date()        const { return m_date; }
    QString payee()     const { return m_payee; }
    QString memo()      const { return m_memo; }
    QString amount()    const { return m_amount; }
    QString category()  const { return m_category; }
    QString status()    const { return m_status; }
    QString number()    const { return m_number; }
    QString addressPayee() const { return m_addressPayee; }

signals:

public slots:

private:
    bool m_valid;
    QDate m_date;
    QRegExp m_dateRegExp;
    QString m_amount;
    QString m_memo;
    QString m_payee;
    QString m_category;
    QString m_status;
    QString m_number;
    QString m_addressPayee;
};

#endif // TRANSACTION_H
