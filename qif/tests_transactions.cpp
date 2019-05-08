#include "tests_transactions.h"

tests_transactions::tests_transactions(QObject *parent):
    QObject(parent)
{

}

void tests_transactions::testCase_Transaction_date()
{
    {
        QStringList data;
        data << "D30/12'2002";
        QifTransaction transaction(data);
        QVERIFY(transaction.date().toString("dd/MM/yyyy") == "30/12/2002");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "D03/12'2002";
        QifTransaction transaction(data);
        QVERIFY(transaction.date().toString("dd/MM/yyyy") == "03/12/2002");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "D3/1'2002";
        QifTransaction transaction(data);
        QVERIFY(transaction.date().toString("dd/MM/yyyy") == "03/01/2002");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "D3/1'02";
        QifTransaction transaction(data);
        QVERIFY2(transaction.date().toString("dd/MM/yyyy") == "", transaction.date().toString("dd/MM/yyyy").toUtf8());
        QVERIFY(transaction.isValid() == false);
    }

    {
        QStringList data;
        data << "D3/1'2";
        QifTransaction transaction(data);
        QVERIFY(transaction.date().toString("dd/MM/yyyy") == "");
        QVERIFY(transaction.isValid() == false);
    }
}

void tests_transactions::testCase_Transaction_amount()
{
    {
        QStringList data;
        data << "T10.00";
        QifTransaction transaction(data);
        QVERIFY(transaction.amount() == "10");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "T-10.02";
        QifTransaction transaction(data);
        QVERIFY(transaction.amount() == "-10.02");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "T+19.90";
        QifTransaction transaction(data);
        QVERIFY(transaction.amount() == "19.9");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "T+1900.90";
        QifTransaction transaction(data);
        QVERIFY(transaction.amount() == "1900.9");
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "T+1,900.90";
        QifTransaction transaction(data);
        QVERIFY2(transaction.amount() == "1900.9", transaction.amount().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_memo()
{
    {
        QStringList data;
        data << "MMemo test";
        QifTransaction transaction(data);
        QVERIFY2(transaction.memo() == "Memo test", transaction.memo().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_status()
{
    {
        QStringList data;
        data << "C ";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "not cleared", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "C";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "not cleared", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "C*";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "cleared", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "Cc";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "cleared", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "CX";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "reconciled", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "CR";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "reconciled", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "CZ";
        QifTransaction transaction(data);
        QVERIFY2(transaction.status() == "", transaction.status().toUtf8());
        QVERIFY(transaction.isValid() == false);
    }
}

void tests_transactions::testCase_Transaction_number()
{
    {
        QStringList data;
        data << "N500";
        QifTransaction transaction(data);
        QVERIFY2(transaction.number() == "500", transaction.number().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_payee()
{
    {
        QStringList data;
        data << "PStandard Oil, Inc.";
        QifTransaction transaction(data);
        QVERIFY2(transaction.payee() == "Standard Oil, Inc.", transaction.payee().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_addresspayee()
{
    {
        QStringList data;
        data << "A101 Main St.";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.addressPayee() == "101 Main St.", transaction.addressPayee().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}


void tests_transactions::testCase_Transaction_category()
{
    {
        QStringList data;
        data << "LFuel:car";
        QifTransaction transaction(data);
        QVERIFY2(transaction.category() == "Fuel:car", transaction.category().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_split_category()
{
    {
        QStringList data;
        data << "Sgas from Esso";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitCategory() == "gas from Esso", transaction.splitCategory().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_split_memo()
{
    {
        QStringList data;
        data << "Ework trips";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitMemo() == "work trips", transaction.splitMemo().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_split_amount()
{
    {
        QStringList data;
        data << "$10.00";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitAmount() == "10.0", transaction.splitAmount().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "$-10.02";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitAmount() == "-10.02", transaction.splitAmount().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "$+19.90";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitAmount() == "19.9", transaction.splitAmount().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "$+1900.90";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitAmount() == "1900.9", transaction.splitAmount().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }

    {
        QStringList data;
        data << "$+1,900.90";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitAmount() == "1900.9", transaction.splitAmount().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_split_percent()
{
    {
        QStringList data;
        data << "%50";
        QifTransaction transaction(data);
//        QVERIFY2(transaction.splitPercent() == "50", transaction.splitPercent().toUtf8());
        QVERIFY(transaction.isValid() == true);
    }
}

void tests_transactions::testCase_Transaction_split_transaction()
{
    {
        QStringList data;
        data << "D24/03'2008" << "C*" << "T-41.40" << "PSTE LAS MARTINES L ISLE JOURDA" << "LGolf:Green Fee";
        data << "SGolf:Green Fee" << "$-22.00" << "SAlimentation:Restaurant" << "$-19.40";
        QifTransaction transaction(data);
        QVERIFY(transaction.date().toString("dd/MM/yyyy") == "24/03/2008");
        QVERIFY2(transaction.status() == "cleared", transaction.status().toUtf8());
        QVERIFY2(transaction.category() == "Golf:Green Fee", transaction.category().toUtf8());
        QVERIFY2(transaction.payee() == "STE LAS MARTINES L ISLE JOURDA", transaction.payee().toUtf8());
        QVERIFY2(transaction.amount() == "-41.4", transaction.amount().toUtf8());

        QVERIFY(transaction.isValid() == true);
    }



//    self.assertEqual([{'split_category': 'Golf:Green Fee',
//                       'split_amount': -22.0},
//                      {'split_category': 'Alimentation:Restaurant',
//                       'split_amount': -19.4}], elt.l_splits)
}
