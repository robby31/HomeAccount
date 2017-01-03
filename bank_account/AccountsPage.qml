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

    property alias model: accountsListView.model

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
                model: accountsPage.model
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

