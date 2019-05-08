QT       += testlib network widgets qml quick xml sql

QT      -= gui

TARGET = tst_request
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp tests_transactions.cpp \
    tests_qiffile.cpp

HEADERS += tests_transactions.h \
    tests_qiffile.h

include (../common/common.pri)
include (qif.pri)


