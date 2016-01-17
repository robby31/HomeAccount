#include <iostream>

#include "tests_transactions.h"
#include "tests_qiffile.h"

void executeTest(QObject* test, QStringList* summary, int argc, char *argv[]) {
    if (QTest::qExec(test, argc, argv) == 0) {
        summary->append(QString(test->metaObject()->className()) + ": OK");
    } else {
        summary->append(QString(test->metaObject()->className()) + ": KO");
    }
}

int main(int argc, char *argv[])
{
    QStringList testsSummary;

    tests_transactions test1;
    executeTest(&test1, &testsSummary, argc, argv);

    tests_qiffile test2;
    executeTest(&test2, &testsSummary, argc, argv);

    // print the results summary
    std::cout << std::endl;
    std::cout << "Summary:" << std::endl;
    foreach(QString result, testsSummary) {
        std::cout << result.toStdString() << std::endl;
    }
}

