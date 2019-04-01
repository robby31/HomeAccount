import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import MyComponents 1.0
import SqlModel 1.0

ColumnLayout {
    id: mainLayout

    spacing: 10

    property int accountId: -1
    property int transactionId: -1
    property date transactionDate
    property double transactionAmount: -1
    property string unit: "€"

    TransactionsModel {
        id: transactionsModel
        onDataChanged: totalModel.reload()
        onRowCountChanged: {
            check_split_id(transactionId)
            totalModel.reload()
        }
    }

    SqlQueryModel {
        id: totalModel
        connectionName: "ACCOUNTS"
        query: transactionsModel.query ? "SELECT SUM(amount) AS total FROM (%1)".arg(transactionsModel.query) : ""
        onModelReset: {
            if (totalModel.rowCount >= 1)
                total.value = totalModel.get(0).total
            else
                total.value = 0.0
        }
    }

    function updateTransactionsQuery()
    {
        if (listview.model)
        {
            if (accountId >= 0 && transactionId >= 0) {
                if (textFilter.text) {
                    listview.model.query = "select * from transactions"
                    listview.model.filter = "account_id=%1 and split_id=%3 and %2".arg(accountId).arg(textFilter.text).arg(transactionId)
                    listview.model.orderClause = "ORDER BY date DESC, abs(amount) DESC"
                }
                else {
                    listview.model.query = "select * from transactions"
                    listview.model.filter = "account_id=%1 and split_id=%2".arg(accountId).arg(transactionId)
                    listview.model.orderClause = "ORDER BY date DESC, abs(amount) DESC"
                }

                listview.model.select()
            }
        }
    }

    function reload() {
        updateTransactionsQuery()
    }

    RowLayout {
        id: rowLayout
        spacing: 10

        MyButton {
            sourceComponent: Text { text: "< Back" }
            onButtonClicked: stack.pop()
        }

        Text {
            id: textAccountName
            text: accountName
            font.bold: true
            Layout.preferredWidth: contentWidth
            clip: true
        }

        TextField {
            id: textFilter
            height: 20
            clip: true
            placeholderText: "Filter transactions"
            selectByMouse: true
            Layout.preferredWidth: 400
            onAccepted: updateTransactionsQuery()

            background: Rectangle {
                color: parent.focus ? "white" : "transparent"
                border.color: parent.focus ? "#21be2b" : "grey"
            }
        }

        Row {
            Layout.fillWidth: true
            layoutDirection: Qt.RightToLeft
            spacing: 10
            clip: true

            Text {
                id: transactionAmountText
                anchors.verticalCenter: parent.verticalCenter
                width: contentWidth
                text: "%1 %2".arg(Number(transactionAmount).toLocaleString(Qt.locale())).arg(transactionsPage.unit)
                color: "blue"
                clip: true
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: contentWidth
                text: "-"
                clip: true
            }

            Text {
                id: total
                anchors.verticalCenter: parent.verticalCenter
                width: contentWidth
                color: transactionAmountText.text !== text ? "red" : "green"
                clip: true

                property double value: 0.0
                text: "%1 %2".arg(Number(value).toLocaleString(Qt.locale())).arg(transactionsPage.unit)
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                text: "+ Add transaction"
                onClicked: drawer.open()
            }
        }

    }

    ListView {
        id: listview

        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        model: transactionsModel
        delegate: TransactionsDelegate { unit: mainLayout.unit }
        currentIndex: 0

        focus: true

        ScrollBar.vertical: ScrollBar { }

        Component.onCompleted: updateTransactionsQuery()
    }

    Drawer {
        id: drawer
        width: parent.width
        height: creationArea.height + 20
        edge: Qt.BottomEdge

        TransactionCreationArea {
            id: creationArea

            height: 300

            parent_date: transactionDate

            anchors { verticalCenter: parent.verticalCenter ; horizontalCenter: parent.horizontalCenter }

            onCreate_transaction: {
                if (accountId >= 0)
                    transactionsModel.create_split_transaction(accountId, transactionId, date, payee, memo, amount)
            }
        }
    }
}


