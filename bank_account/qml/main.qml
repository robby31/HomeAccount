import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import MyComponents 1.0

MyApplication {
    id: mainWindow
    title: "Bank Account"
    width: 900
    height: 600
    logoCompany: "qrc:///images/logo.png"

    property var pageLoaded

    controller: accountsController
    srcPages: _app.databaseName === "" ? "home.qml" : "AccountsPage.qml"

    function closeTransactions() {
        mainWindow.setPage(Qt.resolvedUrl("AccountsPage.qml"), {})
    }

    function selectAccountforTransactions(id, name) {
        mainWindow.setPage(Qt.resolvedUrl("TransactionsPage.qml"), {"accountId": id, "accountName": name})
    }

    onItemLoaded: pageLoaded = item
}
