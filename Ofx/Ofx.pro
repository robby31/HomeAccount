QT += testlib
QT -= gui

CONFIG += qt console warn_on depend_includepath testcase
CONFIG -= app_bundle
CONFIG += sdk_no_version_check

TEMPLATE = app

SOURCES +=  tst_tst_ofx.cpp

include (../common/common.pri)
include (ofx.pri)

INCLUDEPATH += $$(MYLIBRARY)/include/analyzer
LIBS += -L$$(MYLIBRARY)/lib -l$$qtLibraryTarget(analyzer)

INCLUDEPATH += $$(MYLIBRARY)/include/QmlApplication
LIBS += -L$$(MYLIBRARY)/lib -l$$qtLibraryTarget(QmlApplication)

DISTFILES += \
    ofx.pri
