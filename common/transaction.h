#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QObject>
#include <QHash>
#include <QRegExp>
#include <QDate>

#include <QDebug>
#include "debuginfo.h"

class Transaction : public QObject
{
    Q_OBJECT

public:
    explicit Transaction(QObject *parent = Q_NULLPTR);

    bool isValid()      const { return m_valid; }
    void setValid(const bool &flag);

    QDate date()        const { return m_date; }
    void setDate(const QDate &date);

    QString payee()     const { return m_payee; }
    void setPayee(const QString &payee);

    QString memo()      const { return m_memo; }
    void setMemo(const QString &memo);

    QString amount()    const { return m_amount; }
    void setAmount(const QString &amount);

    QString category()  const { return m_category; }
    void setCategory(const QString &category);

    QString status()    const { return m_status; }
    void setStatus(const QString &status);

    QString number()    const { return m_number; }
    void setNumber(const QString &number);

    QString addressPayee() const { return m_addressPayee; }
    void setAddressPayee(const QString &addresPayee);

signals:

public slots:

private:
    bool m_valid = false;
    QDate m_date;
    QString m_amount;
    QString m_memo;
    QString m_payee;
    QString m_category;
    QString m_status;
    QString m_number;
    QString m_addressPayee;
};

#endif // TRANSACTION_H
