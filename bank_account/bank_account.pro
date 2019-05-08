QT += qml quick widgets sql webview charts

TARGET = bank_account

CONFIG += c++14

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    myapplication.cpp \
    accountscontroller.cpp \
    accountsworker.cpp \
    transactionsmodel.cpp \
    accountsmodel.cpp

HEADERS += \
    myapplication.h \
    accountscontroller.h \
    accountsworker.h \
    transactionsmodel.h \
    accountsmodel.h

RESOURCES += \
    data.qrc

include (../common/common.pri)
include (../qif/qif.pri)
include (../Ofx/ofx.pri)

INCLUDEPATH += $$(MYLIBRARY)/$$QT_VERSION/include/analyzer
LIBS += -L$$(MYLIBRARY)/$$QT_VERSION -l$$qtLibraryTarget(analyzer)

INCLUDEPATH += $$(MYLIBRARY)/$$QT_VERSION/include/QmlApplication
LIBS += -L$$(MYLIBRARY)/$$QT_VERSION -l$$qtLibraryTarget(QmlApplication)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += /Users/doudou/workspaceQT/qmlmodulesplugins

mac {
    ICON = icon.icns
}

DISTFILES += \
    app.iconset/icon_16x16@2x.png \
    app.iconset/icon_32x32@2x.png \
    app.iconset/icon_128x128@2x.png \
    app.iconset/icon_256x256@2x.png \
    app.iconset/icon_512x512@2x.png \
    app.iconset/icon_16x16.png \
    app.iconset/icon_32x32.png \
    app.iconset/icon_128x128.png \
    app.iconset/icon_256x256.png \
    app.iconset/icon_512x512.png \
    app.iconset/icon.png \
    ModelEditableText.qml
