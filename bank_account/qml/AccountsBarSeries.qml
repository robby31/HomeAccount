import QtQuick 2.0
import QtCharts 2.0

ChartView {
    title: "Accounts"

    property alias model: mapper.model

    legend { alignment: Qt.AlignBottom }

    antialiasing: true

    function updateAxisX(model, rowCount) {
        var data = []
        for (var i=0;i<rowCount;++i) {
            var name = model.get(i, "name")
            if (name==="")
                name = "<empty>"
            data.push(name)
        }

        axisXCategories.categories = data
    }

    BarSeries {
        id: mySeries

        axisX: BarCategoryAxis { id: axisXCategories }

        VBarModelMapper {
            id: mapper
            firstBarSetColumn: 3
            lastBarSetColumn: 3
            firstRow: 0
            rowCount: model.rowCount
            series: mySeries

            onModelReplaced: updateAxisX(mapper.model, mapper.rowCount)
        }

        onClicked: selectAccountforTransactions(mapper.model.get(index, "id"), mapper.model.get(index, "name"))
    }
}
