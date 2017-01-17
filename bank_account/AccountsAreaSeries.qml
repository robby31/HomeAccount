import QtQuick 2.0
import QtCharts 2.0
import MyComponents 1.0

ChartView {
    id: chartView
    title: "Accounts"

    legend { alignment: Qt.AlignBottom }

    antialiasing: true

    function updateAxis(model) {
        var xmin = -1
        var xmax = -1
        for (var i=0;i<model.rowCount;++i) {
            var year = model.get(i, "year")
            if (xmin == -1)
                xmin = year
            else if (year < xmin)
                xmin = year
            if (xmax == -1)
                xmax = year
            else if (year > xmax)
                xmax = year
        }

        if (xmin!=-1 && xmax!=-1 && xmin < xmax) {
            --xmin
            ++xmax
            axisXValue.min = xmin
            axisXValue.max = xmax
            if (xmax-xmin+1<50)
                axisXValue.tickCount = xmax-xmin+1
        }
    }

    SqlListModel {
        id: sqlModel
        connectionName: "ACCOUNTS"
        query: "SELECT year, (SELECT round(SUM(balanceTable.amount)) from transactions balanceTable WHERE balanceTable.split_id=0 and strftime('%Y', balanceTable.date)<=year) AS total FROM (SELECT DISTINCT strftime('%Y', date) AS year FROM transactions ORDER BY year)"
    }

    ValueAxis { id: axisXValue; labelFormat: "%d"; min: 0; max: 10 }

    AreaSeries {
        name: "Balance (euros)"
        color: "steelblue"
        borderColor: "transparent"
        borderWidth: 2

        pointLabelsVisible: true
        pointLabelsFormat: "@yPoint"
        pointLabelsFont: Qt.font({ pixelSize: 12 })

        axisX: axisXValue

        upperSeries: LineSeries {
            id: mySeries

            VXYModelMapper {
                id: mapper
                xColumn: 0
                yColumn: 1
                firstRow: 0
                rowCount: model.rowCount
                series: mySeries
                model: sqlModel

                onModelReplaced: updateAxis(mapper.model)
            }
        }
    }
}
