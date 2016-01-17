#ifndef TESTS_QIFFILE_H
#define TESTS_QIFFILE_H

#include <QObject>
#include <QtTest>
#include "qiffile.h"

class tests_qiffile : public QObject
{
    Q_OBJECT
public:
    explicit tests_qiffile(QObject *parent = 0);

signals:

public slots:

private Q_SLOTS:
    void testCase_invalid_file();
    void testCase_commun();
    void testCase_cel();
    void testCase_oldcel();
    void testCase_Macfile();
};

#endif // TESTS_QIFFILE_H
