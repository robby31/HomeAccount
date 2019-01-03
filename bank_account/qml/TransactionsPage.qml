import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import MyComponents 1.0

Page {
    id: transactionsPage

    width: 100
    height: 62

    property int accountId: -1
    property string accountName: ""
    property string unit: "€"

    actions: transactionsPageActions

    ListModel {
        id: transactionsPageActions

        ListElement {
            name: "Import QIF"
            description: "import QIF file"
            icon: "qrc:///images/document-open.png"
        }

        ListElement {
            name: "Close"
            description: "close transactions"
            icon: "qrc:///images/exit.png"
        }
    }

    function reloadDatabase() {
        stack.currentItem.reload()
        categoryModel.reload()
    }

    function importQIF() {
        if (accountId >= 0) {
            qifFileDialog.idAccount = accountId
            qifFileDialog.open()
        }
    }

    onActionClicked: {
        if (name == "Close")
            closeTransactions()
        else if (name == "Import QIF")
            importQIF()
    }

    ListModel {
        id: statusModel
        ListElement { value: "" }
        ListElement { value: "reconciled" }
        ListElement { value: "cleared" }
    }

    SqlListModel {
        id: categoryModel
        connectionName: "ACCOUNTS"
        query: "SELECT DISTINCT category FROM transactions ORDER BY category"
    }

    function selectDetails(id, amount, date) {
        stack.push("SplitTransactionListView.qml", {"accountId": accountId, "transactionId": id, "transactionAmount": amount, "transactionDate": date, "unit": transactionsPage.unit})
    }

    StackView {
        id: stack

        anchors.fill: parent
        anchors.margins: 10

        Component.onCompleted: stack.push("TransactionsListView.qml", {"accountId": accountId, "unit": transactionsPage.unit})
    }

    FileDialog {
        id: qifFileDialog
        nameFilters: [ "QIF file (*.qif)" ]
        selectExisting: true
        property int idAccount: -1
        onAccepted: importQif(idAccount, fileUrl)
    }
}
