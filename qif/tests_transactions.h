#ifndef TESTS_TRANSACTIONS_H
#define TESTS_TRANSACTIONS_H

#include <QObject>
#include <QtTest>
#include "qiftransaction.h"

class tests_transactions : public QObject
{
    Q_OBJECT

public:
    explicit tests_transactions(QObject *parent = Q_NULLPTR);

signals:

public slots:

private Q_SLOTS:
    void testCase_Transaction_date();
    void testCase_Transaction_amount();
    void testCase_Transaction_memo();
    void testCase_Transaction_status();
    void testCase_Transaction_number();
    void testCase_Transaction_payee();
    void testCase_Transaction_addresspayee();
    void testCase_Transaction_category();

    void testCase_Transaction_split_category();
    void testCase_Transaction_split_memo();
    void testCase_Transaction_split_amount();
    void testCase_Transaction_split_percent();
    void testCase_Transaction_split_transaction();

};

#endif // TESTS_TRANSACTIONS_H
