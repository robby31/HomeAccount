import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtCharts 2.0
import MyComponents 1.0
import Models 1.0

ColumnLayout {
    SqlListModel {
        id: yearModel
        connectionName: "ACCOUNTS"
        query: "SELECT DISTINCT strftime('%Y', date) AS year from transactions WHERE split_id=0 ORDER BY year"
    }

    SqlListModel {
        id: sqlModel
        connectionName: "ACCOUNTS"
        query: "SELECT maincategory, total, abs(total) AS balance FROM (SELECT CASE WHEN instr(category, ':')!=0 THEN substr(category, 1, instr(category, ':')-1) ELSE category END AS maincategory, sum(amount) AS total from transactions WHERE split_id=0 and strftime('%Y', date)='%1' GROUP BY maincategory) ORDER BY balance DESC".arg(comboYear.currentText)
        onQueryChanged: mySeries.updateAxis(sqlModel, mapper.firstRow, mapper.rowCount)

        Component.onCompleted: {
            addColumnToFilter("maincategory")
        }
    }

    Row {
        ComboBox {
            id: comboYear
            height: 20

            model: yearModel
            textRole: "year"

            delegate: ItemDelegate {
                width: comboYear.width
                height: comboYear.height
                contentItem: Text {
                    text: modelData
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
        }

        Button {
            height: 20
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

            axisY: BarCategoryAxis { id: axisYCategories }

            labelsVisible: true

            function updateAxis(model, firstRow, rowCount) {
                var data = []
                var xmin = -1
                var xmax = -1
                for (var i=firstRow;i<rowCount;++i) {
                    data.push(model.get(i, "maincategory"))

                    var value = model.get(i, "balance")
                    if (xmin==-1)
                        xmin = value;
                    else if (value < xmin)
                        xmin = value;
                    if (xmax == -1)
                        xmax = value;
                    else if (value > xmax)
                        xmax = value;
                }

                axisYCategories.categories = data

                if (xmin < xmax) {
                    mySeries.axisX.min = xmin
                    mySeries.axisX.max = xmax
                    mySeries.axisX.applyNiceNumbers()
                }
            }

            VBarModelMapper {
                id: mapper
                firstBarSetColumn: 2
                lastBarSetColumn: 2
                firstRow: 0
                rowCount: 20
                model: sqlModel

                onModelReplaced: mySeries.updateAxis(mapper.model, mapper.firstRow, mapper.rowCount)
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

            columnModel: sqlModel.columnsToFilter
            columnDataModel: sqlModel.columnDataModel

            onOk: {
                filterDialog.isVisible = false
                sqlModel.updateFilter()
            }

            onColumnSelected: sqlModel.setColumnDataModel(name)
        }
    }
}
