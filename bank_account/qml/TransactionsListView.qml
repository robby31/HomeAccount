import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import MyComponents 1.0

ColumnLayout {
    id: mainLayout

    spacing: 10

    property int accountId: -1
    property string unit: "€"


    onVisibleChanged: {
        if (visible == true)
        {
            // update model if is_split changed
            transactionsModel.reload()
        }
    }

    SqlListModel {
        id: transactionsModel
        connectionName: "ACCOUNTS"
        onRowsRemoved: balanceModel.reload()
    }

    SqlListModel {
        id: balanceModel
        connectionName: "ACCOUNTS"
        query: "SELECT sum(amount) AS total from transactions WHERE account_id=%1 and split_id=0".arg(accountId)
        onModelReset: {
            if (balanceModel.rowCount >= 1) {
                var value = balanceModel.get(0, "total")
                balanceText.text = "%1 %2".arg(Number(value).toLocaleString(Qt.locale())).arg(transactionsPage.unit)
                if (value < 0)
                    balanceText.color = "red"
                else
                    balanceText.color = "blue"
            }
        }
    }

    function updateTransactionsQuery()
    {
        if (listview.model)
        {
            if (accountId >= 0) {
                listview.model.tablename = "transactions"
                if (textFilter.text)
                {
                    listview.model.query = "select * from transactions where account_id=%1 and split_id=0 and %2 ORDER BY date DESC, abs(amount) DESC".arg(accountId).arg(textFilter.text)
                    balanceModel.query = "SELECT sum(amount) AS total from (%1)".arg(listview.model.query)
                }
                else
                {
                    listview.model.query = "select *, (SELECT SUM(balanceTable.amount) from transactions balanceTable WHERE balanceTable.account_id=%1 and balanceTable.split_id=0 and balanceTable.date<=transactions.date) AS balance from transactions where account_id=%1 and split_id=0 ORDER BY date DESC, abs(amount) DESC".arg(accountId)
                    balanceModel.query = "SELECT sum(amount) AS total from transactions WHERE account_id=%1 and split_id=0".arg(accountId)
                }
            }
        }
    }

    function reload() {
        transactionsModel.reload()
        balanceModel.reload()
    }

    RowLayout {
        id: rowLayout
        spacing: 10

        MyButton {
            sourceComponent: Text { text: "< Accounts" }
            onButtonClicked: closeTransactions()
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
                id: balanceText
                anchors.verticalCenter: parent.verticalCenter
                width: contentWidth
                clip: true
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                text: "+ Add transaction"
                onClicked: drawer.open()
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                text: "Import QIF"
                onClicked: importQIF()
            }
        }

    }

    ListView {
        id: listview

        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        model: transactionsModel
        delegate: TransactionsDelegate { splitEnabled: true; unit: mainLayout.unit }
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

            anchors { verticalCenter: parent.verticalCenter ; horizontalCenter: parent.horizontalCenter }

            onCreate_transaction: {
                if (accountId >= 0)
                    create_new_transaction(accountId, date, payee, memo, amount)
            }
        }
    }
}

