import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import MyComponents 1.0
import SqlModel 1.0

ColumnLayout {
    id: mainLayout

    spacing: 10

    property int accountId: -1
    property string unit: "€"


    onVisibleChanged: {
        if (visible == true)
        {
            // update model if is_split changed
            transactionsModel.select()
        }
    }

    TransactionsModel {
        id: transactionsModel
        orderClause: "ORDER BY date DESC, abs(amount) DESC"

        onRowCountChanged: balanceModel.reload()
        onDataChanged: balanceModel.reload()
    }

    SqlQueryModel {
        id: balanceModel
        connectionName: "ACCOUNTS"
        query: "SELECT sum(amount) AS total from transactions WHERE account_id=%1 and split_id=0".arg(accountId)
        onModelReset: {
            if (balanceModel.rowCount >= 1)
                balanceText.value = balanceModel.get(0).total
            else
                balanceText.value = 0.0
        }
    }

    function updateTransactionsQuery()
    {
        if (listview.model)
        {
            if (accountId >= 0) {
                if (textFilter.text)
                {
                    listview.model.query = "select * from transactions"
                    listview.model.filter = "account_id=%1 and split_id=0 and %2".arg(accountId).arg(textFilter.text)
                    listview.model.select()

                    balanceModel.query = "SELECT sum(amount) AS total from (%1)".arg(listview.model.query)
                }
                else
                {
                    listview.model.query = "select *, (SELECT SUM(balanceTable.amount) from transactions balanceTable WHERE balanceTable.account_id=%1 and balanceTable.split_id=0 and balanceTable.date<=transactions.date) AS balance from transactions".arg(accountId)
                    listview.model.filter = "account_id=%1 and split_id=0".arg(accountId)
                    listview.model.select()

                    balanceModel.query = "SELECT sum(amount) AS total from transactions WHERE account_id=%1 and split_id=0".arg(accountId)
                }
            }
        }
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

                property double value: 0.0
                text: "%1 %2".arg(Number(value).toLocaleString(Qt.locale())).arg(transactionsPage.unit)
                color: value < 0 ? "red" : "blue"
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
                onClicked: {
                    if (accountId >= 0) {
                        qifFileDialog.idAccount = accountId
                        qifFileDialog.open()
                    }
                }
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                text: "Import OFX"
                onClicked: {
                    if (accountId >= 0) {
                        ofxFileDialog.idAccount = accountId
                        ofxFileDialog.open()
                    }
                }
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
                    transactionsModel.create_transaction(accountId, date, payee, memo, amount)
            }
        }
    }

    FileDialog {
        id: qifFileDialog
        nameFilters: [ "QIF file (*.qif)" ]
        selectExisting: true
        property int idAccount: -1
        onAccepted: transactionsModel.importQif(idAccount, fileUrl)
    }

    FileDialog {
        id: ofxFileDialog
        nameFilters: [ "OFX file (*.ofx)" ]
        selectExisting: true
        property int idAccount: -1
        onAccepted: transactionsModel.importOfx(idAccount, fileUrl)
    }
}

