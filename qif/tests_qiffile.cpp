#include "tests_qiffile.h"

tests_qiffile::tests_qiffile(QObject *parent) : QObject(parent)
{

}

void tests_qiffile::cleanupTestCase()
{
    DebugInfo::display_alive_objects();
    QCOMPARE(DebugInfo::count_alive_objects(), 0);
}

void tests_qiffile::testCase_invalid_file()
{
    QifFile file;

    QVERIFY2(!file.read(QUrl("file:///Users/doudou/workspaceQT/HomeAccount/qif/data/invalid_type.qif")), "ERROR, function read returned true, it shall return false because the type is invalid.");
}

void tests_qiffile::testCase_commun()
{
    QifFile file;
    file.setCodecName("ISO 8859-15");

    QVERIFY2(file.read(QUrl("file:///Users/doudou/workspaceQT/HomeAccount/qif/data/BNP_commun.qif")), "ERROR, function read returned false.");

    QVERIFY2(file.type() == "Bank", QString("ERROR, invalid type %1").arg(file.type()).toUtf8());

    QVERIFY2(file.size() == 12, QString("ERROR, invalid transactions size %1").arg(file.size()).toUtf8());

    Transaction *transaction = Q_NULLPTR;

    transaction = file.transaction(0);
    QVERIFY(transaction != Q_NULLPTR);

    QVERIFY2(transaction->date().toString("dd/MM/yyyy") == "18/09/2012", QString("ERROR, invalid date %1").arg(transaction->date().toString("dd/MM/yyyy")).toUtf8());
    QVERIFY2(transaction->payee() == "16/09/12 10H20 13319000 CE MIDI-", QString("ERROR, invalid payee %1").arg(transaction->payee()).toUtf8());
    QVERIFY2(transaction->memo() == "RETRAIT DAB             16/09/12 10H20 13319000 CE MIDI-PYRENEES", QString("ERROR, invalid memo %1").arg(transaction->memo()).toUtf8());
    QVERIFY2(transaction->amount() == "-60", QString("ERROR, invalid amount %1").arg(transaction->amount()).toUtf8());

    transaction = file.transaction(2);
    QVERIFY(transaction != Q_NULLPTR);

    QVERIFY2(transaction->date().toString("dd/MM/yyyy") == "17/09/2012", QString("ERROR, invalid date %1").arg(transaction->date().toString("dd/MM/yyyy")).toUtf8());
    QVERIFY2(transaction->payee() == "N° 1305751", QString("ERROR, invalid payee %1").arg(transaction->payee()).toUtf8());
    QVERIFY2(transaction->memo() == "CHEQUE                  N° 1305751", QString("ERROR, invalid memo %1").arg(transaction->memo()).toUtf8());
    QVERIFY2(transaction->amount() == "-155", QString("ERROR, invalid amount %1").arg(transaction->amount()).toUtf8());
}

void tests_qiffile::testCase_cel()
{
    QifFile file;
    file.setCodecName("ISO 8859-15");

    QVERIFY2(file.read(QUrl("file:///Users/doudou/workspaceQT/HomeAccount/qif/data/CEL.qif")), "ERROR, function read returned false.");

    QVERIFY2(file.type() == "Bank", QString("ERROR, invalid type %1").arg(file.type()).toUtf8());

    QVERIFY2(file.size() == 151, QString("ERROR, invalid transactions size %1").arg(file.size()).toUtf8());

    Transaction *transaction = Q_NULLPTR;

    transaction = file.transaction(3);
    QVERIFY(transaction != Q_NULLPTR);

    QVERIFY2(transaction->date().toString("dd/MM/yyyy") == "30/12/2002", QString("ERROR, invalid date %1").arg(transaction->date().toString("dd/MM/yyyy")).toUtf8());
    QVERIFY2(transaction->payee() == "Opening Balance", QString("ERROR, invalid payee %1").arg(transaction->payee()).toUtf8());
    QVERIFY2(transaction->memo() == "", QString("ERROR, invalid memo %1").arg(transaction->memo()).toUtf8());
    QVERIFY2(transaction->amount() == "304.9", QString("ERROR, invalid amount %1").arg(transaction->amount()).toUtf8());
    QVERIFY2(transaction->status() == "reconciled", QString("ERROR, invalid status %1").arg(transaction->status()).toUtf8());
    QVERIFY2(transaction->category() == "Virmt depuis un compte supprimé", QString("ERROR, invalid category %1").arg(transaction->category()).toUtf8());

//    # save new QIF file
//    qif.save(u'new_cel.qif')

//    new_qif = Qif()
//    new_qif.read(u'new_cel.qif')

//    self.assertEqual(new_qif.type_qif, 'Bank')

//    self.assertEqual('Bank', new_qif.get_type())

//    new_transactions = new_qif.get_transactions()
//    self.assertEqual(len(new_transactions), 151)

//    # compare transactions of new file with older one
//    self.assertEqual(transactions, new_transactions)

//    for index, elt in enumerate(transactions):
//        if elt.l_splits:
//            self.assertEqual(elt.l_splits, new_transactions[index].l_splits)

//    os.remove('new_cel.qif')
}

void tests_qiffile::testCase_oldcel()
{
    QifFile file;

    QVERIFY2(file.read(QUrl("file:///Users/doudou/workspaceQT/HomeAccount/qif/data/old_CEL.qif")), "ERROR, function read returned false.");

    QVERIFY2(file.type() == "Bank", QString("ERROR, invalid type %1").arg(file.type()).toUtf8());

    QVERIFY2(file.size() == 98, QString("ERROR, invalid transactions size %1").arg(file.size()).toUtf8());
}

void tests_qiffile::testCase_Macfile()
{
    QifFile file;

    QVERIFY2(file.read(QUrl("file:///Users/doudou/workspaceQT/HomeAccount/qif/data/E3548729.qif")), "ERROR, function read returned false.");

    QVERIFY2(file.type() == "Bank", QString("ERROR, invalid type %1").arg(file.type()).toUtf8());

    QVERIFY2(file.size() == 12, QString("ERROR, invalid transactions size %1").arg(file.size()).toUtf8());
}
