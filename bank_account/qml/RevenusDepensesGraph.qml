import QtQuick 2.0
import QtCharts 2.0
import MyComponents 1.0

ChartView {
    id: chartView
    title: "Revenus / Dépenses (euros)"

    legend { alignment: Qt.AlignBottom }

    antialiasing: true

    property color valueTextColor: "black"

    SqlListModel {
        id: sqlModel
        connectionName: "ACCOUNTS"
        query: "SELECT year, (SELECT round(SUM(balanceTable.amount)) from transactions balanceTable WHERE balanceTable.split_id=0 and balanceTable.amount>=0 and strftime('%Y', balanceTable.date)=year) AS Revenus, (SELECT round(SUM(-balanceTable.amount)) from transactions balanceTable WHERE balanceTable.split_id=0 and balanceTable.amount<0 and strftime('%Y', balanceTable.date)=year) AS Depenses FROM (SELECT DISTINCT strftime('%Y', date) AS year FROM transactions ORDER BY year)"
    }

    function updateAxisX(model) {
        var data = []
        var ymax = -1
        for (var i=0;i<model.rowCount;++i) {
            data.push(model.get(i, "year"))

            var tmp = model.get(i, "Revenus")
            if (tmp > ymax)
                ymax = tmp

            tmp = model.get(i, "Depenses")
            if (tmp > ymax)
                ymax = tmp
        }

        axisXCategories.categories = data

        if (ymax > 0) {
            axisYValue.max = ymax
            axisYValue.applyNiceNumbers()
        }
    }

    BarSeries {
        id: mySeries

        axisX: BarCategoryAxis { id: axisXCategories }
        axisY: ValueAxis { id: axisYValue; min: 0 ; max: 10000 }

        VBarModelMapper {
            id: mapper
            firstBarSetColumn: 1
            lastBarSetColumn: 2
            firstRow: 0
            rowCount: model.rowCount
            model: sqlModel

            onModelReplaced: updateAxisX(mapper.model)
        }

        onHovered: {
            var value = sqlModel.get(index, barset.label)
            label.name = barset.label
            label.value = value
            label.visible = status
        }
    }

    Rectangle {
        id: label
        anchors { bottom: parent.bottom; right: parent.right; bottomMargin: 50; rightMargin: 50 }
        width: textLabel.width+40
        height: textLabel.height+10
        border.color: valueTextColor
        radius: height/4
        visible: false

        property string name: ""
        property real value: 0

        Text {
            id: textLabel
            width: contentWidth
            height: contentHeight
            text: "%1: %2 euros".arg(label.name).arg(label.value)
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
            clip: true
            color: valueTextColor
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
