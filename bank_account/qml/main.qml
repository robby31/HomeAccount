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

    signal importQif(int idAccount, string filename)
    signal create_account(string name, string number)
    signal create_new_transaction(int id_account, date date, string payee, string memo, string amount)
    signal create_new_split_transaction(int id_account, int id_transaction, date date, string payee, string memo, string amount)

    controller: accountsController
    srcPages: _app.databaseName === "" ? "home.qml" : "AccountsPage.qml"

    function reloadDatabase() {
        if (pageLoaded.reloadDatabase)
            pageLoaded.reloadDatabase()
    }

    function closeTransactions() {
        mainWindow.setPage(Qt.resolvedUrl("AccountsPage.qml"), {})
    }

    function selectAccountforTransactions(id, name) {
        mainWindow.setPage(Qt.resolvedUrl("TransactionsPage.qml"), {"accountId": id, "accountName": name})
    }

    onItemLoaded: pageLoaded = item
}
