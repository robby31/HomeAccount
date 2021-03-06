#-------------------------------------------------
#
# Project created by QtCreator 2019-05-08T09:57:32
#
#-------------------------------------------------

QT       -= gui

TARGET = common
TEMPLATE = lib

CONFIG += sdk_no_version_check

DEFINES += COMMON_LIBRARY

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        common.cpp \
        myfile.cpp \
        transaction.cpp

HEADERS += \
        common.h \
        common_global.h  \
        myfile.h \
        transaction.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}

DISTFILES += \
    common.pri

INCLUDEPATH += $$(MYLIBRARY)/include/analyzer
LIBS += -L$$(MYLIBRARY)/lib -l$$qtLibraryTarget(analyzer)

INCLUDEPATH += $$(MYLIBRARY)/include/QmlApplication
LIBS += -L$$(MYLIBRARY)/lib -l$$qtLibraryTarget(QmlApplication)
