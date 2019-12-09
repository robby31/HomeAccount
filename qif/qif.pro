QT       += testlib network widgets qml quick xml sql

QT      -= gui

TARGET = tst_request
CONFIG   += console
CONFIG   -= app_bundle
CONFIG += sdk_no_version_check

TEMPLATE = app

SOURCES += main.cpp tests_transactions.cpp \
    tests_qiffile.cpp

HEADERS += tests_transactions.h \
    tests_qiffile.h

include (../common/common.pri)
include (qif.pri)

INCLUDEPATH += $$(MYLIBRARY)/include/analyzer
LIBS += -L$$(MYLIBRARY)/lib -l$$qtLibraryTarget(analyzer)

INCLUDEPATH += $$(MYLIBRARY)/include/QmlApplication
LIBS += -L$$(MYLIBRARY)/lib -l$$qtLibraryTarget(QmlApplication)

