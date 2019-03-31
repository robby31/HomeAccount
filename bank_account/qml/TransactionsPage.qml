import QtQuick 2.5
import QtQuick.Controls 2.1
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

    }

    function reloadDatabase() {
        stack.currentItem.reload()
        categoryModel.reload()
    }

    onActionClicked: {

    }

    ListModel {
        id: statusModel
        ListElement { value: "" }
        ListElement { value: "reconciled" }
        ListElement { value: "cleared" }
    }

    SqlQueryModel {
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
}
