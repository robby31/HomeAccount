#include <QtTest>

// add necessary includes here
#include "ofxfile.h"

class tst_ofx : public QObject
{
    Q_OBJECT

public:
    tst_ofx() = default;

private slots:
    void cleanupTestCase();
    void test_OfxFile();

};

void tst_ofx::cleanupTestCase()
{
    DebugInfo::display_alive_objects();
    QCOMPARE(DebugInfo::count_alive_objects(), 0);
}

void tst_ofx::test_OfxFile()
{
    OfxFile file;

    QVERIFY2(file.read(QUrl("file:///Users/doudou/workspaceQT/HomeAccount/ofx/data/E1288729.ofx")), "ERROR, function read returned false.");

    QCOMPARE(file.size(), 27);

    Transaction *tr = Q_NULLPTR;

    tr = file.transaction(0);
    QVERIFY(tr != Q_NULLPTR);
    if (tr)
    {
        QVERIFY(tr->isValid());
        QCOMPARE(tr->payee(), "IPECA PREVOYANCE ECH/080419 ID EMETTEUR/FR62ZZZ102296 MDT/++042564901 REF/IPECA - COTISATIONS");
        QCOMPARE(tr->memo(), "IPECA PREVOYANCE ECH/080419 ID EMETTEUR/FR62ZZZ102296 MDT/++042564901 REF/IPECA - COTISATIONS");
        QCOMPARE(tr->amount(), "-105.60");
        QCOMPARE(tr->date().toString("dd MM yyyy"), "07 04 2019");
    }
}

QTEST_APPLESS_MAIN(tst_ofx)

#include "tst_tst_ofx.moc"
