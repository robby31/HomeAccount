import QtQuick 2.3
import QtQuick.Controls 2.1
import MyComponents 1.0

Page {
    id: accountsPage

    width: 100
    height: 62

    actions: accountsPageActions

    onActionClicked: {
        if (name == "Close")
            _app.databaseName = ""
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

    SwipeView {
        id: view
        anchors.fill: parent

        AccountsListView { model: accountsModel }

        AccountsCategories { }

        AccountsBarSeries { model: accountsModel }

        AccountsAreaSeries { }

        RevenusDepensesGraph { }
    }

    PageIndicator {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

