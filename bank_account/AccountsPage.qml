import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import MyComponents 1.0

Page {
    id: accountsPage

    width: 100
    height: 62

    actions: accountsPageActions

    onActionClicked: {
        if (name == "Close")
            closeDatabase()
    }

    ListModel {
        id: accountsPageActions

        ListElement {
            name: "Close"
            description: "close accounts"
            icon: "qrc:///images/exit.png"
        }
    }

    function reloadDatabase() {
        accountsModel.reload()
    }

    SqlListModel {
        id: accountsModel
        connectionName: "ACCOUNTS"
        query: "SELECT id, name, number, (SELECT SUM(transactions.amount) FROM transactions WHERE transactions.account_id=accounts.id and split_id=0) AS amount FROM accounts"
    }

    ListView {
        id: listView
        anchors.fill: parent
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 250
        focus: false
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds

        model:     ObjectModel {

            AccountsListView {
                id: accountsListView
                width: listView.width
                height: listView.height
                model: accountsModel
            }

            AccountsCategories {
                id: categorieSeries
                width: listView.width
                height: listView.height
            }

            AccountsBarSeries {
                id: barSeries
                width: listView.width
                height: listView.height
                model: accountsModel
            }

            AccountsAreaSeries {
                id: areaSeries
                width: listView.width
                height: listView.height
            }

            RevenusDepensesGraph {
                id: revenusdepenses
                width: listView.width
                height: listView.height
            }
        }
    }

}

