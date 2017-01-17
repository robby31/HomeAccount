import QtQuick 2.3
import QtQuick.Controls 1.2
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
        transactionsModel.reload()
    }

    SqlListModel {
        id: transactionsModel
        connectionName: "ACCOUNTS"
    }

    onActionClicked: {
        if (name == "Close")
            closeTransactions()
        else if (name == "Import QIF")
        {
            if (accountId >= 0) {
                qifFileDialog.idAccount = accountId
                qifFileDialog.open()
            }
        }
    }

    function updateTransactionsQuery()
    {
        if (transactions.model)
        {
            if (accountId >= 0) {
                transactions.model.tablename = "transactions"
                if (textFilter.text)
                    transactions.model.query = "select *, (SELECT SUM(balanceTable.amount) from transactions balanceTable WHERE balanceTable.account_id=%1 and balanceTable.split_id=0 and balanceTable.date<=transactions.date) AS balance from transactions where account_id=%1 and split_id=0 and %2 ORDER BY date DESC, abs(amount) DESC".arg(accountId).arg(textFilter.text)
                else
                    transactions.model.query = "select *, (SELECT SUM(balanceTable.amount) from transactions balanceTable WHERE balanceTable.account_id=%1 and balanceTable.split_id=0 and balanceTable.date<=transactions.date) AS balance from transactions where account_id=%1 and split_id=0 ORDER BY date DESC, abs(amount) DESC".arg(accountId)
            }
        }

        categoryModel.reload()
        balanceModel.reload()
    }

    ListModel {
        id: statusModel
        ListElement { text: "" }
        ListElement { text: "reconciled" }
        ListElement { text: "cleared" }
    }


    SqlListModel {
        id: categoryModel
        connectionName: "ACCOUNTS"
        query: "SELECT DISTINCT category FROM transactions ORDER BY category"
    }

    SqlListModel {
        id: balanceModel
        connectionName: "ACCOUNTS"
        query: "SELECT sum(amount) AS total from transactions WHERE account_id=%1 and split_id=0".arg(accountId)
        onModelReset: {
            if (balanceModel.rowCount >= 1) {
                var value = balanceModel.get(0, "total")
                balance.text = "%1 %2".arg(Number(value).toLocaleString(Qt.locale())).arg(transactionsPage.unit)
                if (value < 0)
                    balance.color = "red"
                else
                    balance.color = "blue"
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout {
            id: rowLayout
            spacing: 10

            MyButton {
                sourceComponent: Text { text: "< Back" }
                onButtonClicked: closeTransactions()
            }

            Text {
                id: textAccountName
                text: accountName
                font.bold: true
                Layout.preferredWidth: contentWidth
            }

            TextField {
                id: textFilter
                placeholderText: "Filter transactions"
                Layout.preferredWidth: 400
                onAccepted: updateTransactionsQuery()
            }

            Row {
                Layout.fillWidth: true
                layoutDirection: Qt.RightToLeft
                spacing: 10
                clip: true

                Text {
                    width: contentWidth
                    text: transactions.model.rowCount + " lines"
                    clip: true
                }

                Text {
                    width: contentWidth
                    text: "-"
                    clip: true
                }

                Text {
                    id: balance
                    width: contentWidth
                    clip: true
                }
            }

        }

        TransactionsListView {
            id: transactions

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: transactionsModel
            unit: transactionsPage.unit

            onModelChanged: updateTransactionsQuery()
        }

        TransactionCreationArea {
            id: creationArea

            onCreate_transaction: {
                if (accountId >= 0)
                    create_transaction(accountId, date, payee, memo, Number.fromLocaleString(Qt.locale(), amount))
            }
        }
    }

    FileDialog {
        id: qifFileDialog
        nameFilters: [ "QIF file (*.qif)" ]
        selectExisting: true
        property int idAccount: -1
        onAccepted: importQif(idAccount, fileUrl)
    }
}
