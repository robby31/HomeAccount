import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtCharts 2.0
import MyComponents 1.0

Item {
    SqlListModel {
        id: yearModel
        connectionName: "ACCOUNTS"
        query: "SELECT DISTINCT strftime('%Y', date) AS year from transactions WHERE split_id=0 ORDER BY year"
    }

    SqlListModel {
        id: sqlAccountsModel

        connectionName: "ACCOUNTS"
        query: "SELECT DISTINCT id, name from accounts ORDER BY name"

        onQueryChanged: updateAccountsModel()
        Component.onCompleted: updateAccountsModel()
    }

    function updateAccountsModel() {
        accountsModel.clear()
        accountsModel.append({"account_id": -1, "name": "All"})
        for (var i=0;i<sqlAccountsModel.rowCount;++i) {
            accountsModel.append({"account_id": sqlAccountsModel.get(i, "id"), "name": sqlAccountsModel.get(i, "name")})
        }
        comboAccount.currentIndex = 0
    }

    ListModel {
        id: accountsModel
        ListElement { account_id: -1; name: "All"}

    }

    function updateSqlModelQuery() {
        if (comboAccount.currentIndex <= 0) {
            chartView.title = "Categories (Année %1)".arg(comboYear.currentText)
            mapper.query = "SELECT maincategory, total, abs(total) AS balance FROM (SELECT CASE WHEN instr(category, ':')!=0 THEN substr(category, 1, instr(category, ':')-1) ELSE category END AS maincategory, sum(amount) AS total from transactions WHERE split_id=0 and strftime('%Y', date)='%1' GROUP BY maincategory) ORDER BY balance DESC".arg(comboYear.currentText)
        } else {
            var account_id = accountsModel.get(comboAccount.currentIndex).account_id
            chartView.title = "Categories %2 (Année %1)".arg(comboYear.currentText).arg(comboAccount.currentText)
            mapper.query = "SELECT maincategory, total, abs(total) AS balance FROM (SELECT CASE WHEN instr(category, ':')!=0 THEN substr(category, 1, instr(category, ':')-1) ELSE category END AS maincategory, sum(amount) AS total from transactions WHERE account_id=%2 and split_id=0 and strftime('%Y', date)='%1' GROUP BY maincategory) ORDER BY balance DESC".arg(comboYear.currentText).arg(account_id)
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Row {
            ComboBox {
                id: comboYear

                height: 30
                model: yearModel
                textRole: "year"

                delegate: ItemDelegate {
                    width: comboYear.width
                    height: comboYear.height
                    contentItem: Text {
                        text: year
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    highlighted: comboYear.highlightedIndex == index
                }

                indicator: Canvas {
                    id: canvas
                    x: comboYear.width - width - comboYear.rightPadding
                    y: comboYear.topPadding + (comboYear.availableHeight - height) / 2
                    width: 12
                    height: 8
                    contextType: "2d"

                    Connections {
                        target: comboYear
                        onPressedChanged: canvas.requestPaint()
                    }

                    onPaint: {
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        //                    context.fillStyle = comboYear.pressed ? "#17a81a" : "#21be2b";
                        context.fill();
                    }
                }

                onModelChanged: {
                    // initialize currentIndex with current year or last one
                    var date = new Date()
                    var index = find(date.getFullYear())
                    if (index===-1)
                        index = model.rowCount-1
                    currentIndex = index
                }

                onCurrentTextChanged: updateSqlModelQuery()
            }

            ComboBox {
                id: comboAccount

                height: 30
                model: accountsModel
                textRole: "name"

                delegate: ItemDelegate {
                    width: comboAccount.width
                    height: comboAccount.height
                    contentItem: Text {
                        text: name
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    highlighted: comboAccount.highlightedIndex == index
                }

                indicator: Canvas {
                    id: comboAccountCanvas
                    x: comboAccount.width - width - comboAccount.rightPadding
                    y: comboAccount.topPadding + (comboAccount.availableHeight - height) / 2
                    width: 12
                    height: 8
                    contextType: "2d"

                    Connections {
                        target: comboAccount
                        onPressedChanged: comboAccountCanvas.requestPaint()
                    }

                    onPaint: {
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        //                    context.fillStyle = comboYear.pressed ? "#17a81a" : "#21be2b";
                        context.fill();
                    }
                }

                onModelChanged: currentIndex = 0

                onCurrentTextChanged: updateSqlModelQuery()
            }

            Button {
                height: 30
                text: "Filter"
                onClicked: filterDialog.isVisible = true
            }
        }

        ChartView {
            id: chartView

            Layout.fillWidth: true
            Layout.fillHeight: true

            title: "Categories (Année %1)".arg(comboYear.currentText)
            antialiasing: true

            legend { alignment: Qt.AlignBottom }


            HorizontalBarSeries {
                id: mySeries

                labelsVisible: true

                VSqlBarModelMapper {
                    id: mapper
                    series: mySeries
                    connectionName: "ACCOUNTS"
                    roleCategory: "maincategory"
                    roleValue: ["balance"]
                    firstBarSetColumn: 2
                    lastBarSetColumn: 2
                    firstRow: 0
                    rowCount: 20

                    Component.onCompleted: {
                        model.addColumnToFilter("maincategory")
                    }
                }

            }
        }
    }

    FlippableDialog {
        id: filterDialog
        anchors.fill: parent
        dialogWidth: 600
        dialogHeight: 300

        item: FilteringDialog {
            id: checkedListItem
            columnModel: mapper.model.columnsToFilter
            columnDataModel: mapper.model.columnDataModel

            onOk: {
                filterDialog.isVisible = false
                mapper.model.updateFilter()
            }

            onColumnSelected: mapper.model.setColumnDataModel(name)
        }
    }
}
