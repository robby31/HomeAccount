QT += testlib
QT -= gui

CONFIG += qt console warn_on depend_includepath testcase
CONFIG -= app_bundle

TEMPLATE = app

SOURCES +=  tst_tst_ofx.cpp

include (../common/common.pri)
include (ofx.pri)

INCLUDEPATH += $$(MYLIBRARY)/$$QT_VERSION/include/analyzer
LIBS += -L$$(MYLIBRARY)/$$QT_VERSION -l$$qtLibraryTarget(analyzer)

INCLUDEPATH += $$(MYLIBRARY)/$$QT_VERSION/include/QmlApplication
LIBS += -L$$(MYLIBRARY)/$$QT_VERSION -l$$qtLibraryTarget(QmlApplication)

DISTFILES += \
    ofx.pri
