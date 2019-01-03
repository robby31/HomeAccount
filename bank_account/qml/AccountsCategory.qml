import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtCharts 2.0
import MyComponents 1.0
import SqlModel 1.0

Item {

    SqlQueryModel {
        id: categoryModel
        connectionName: "ACCOUNTS"
        query: "SELECT DISTINCT category from transactions WHERE category is not null and category != '' ORDER BY category"
    }

    TransactionsModel {
        id: amountModel
        connectionName: "ACCOUNTS"
//        query: "SELECT date, amount FROM transactions WHERE category='%1'".arg(comboCategory.currentText)
        query: "SELECT CAST(strftime('%Y', date) AS INT) AS year, sum(amount) AS total FROM transactions WHERE category='%1' GROUP BY year".arg(comboCategory.currentText)
    }

    ColumnLayout {
        anchors.fill: parent

        ComboBox {
            id: comboCategory
            width: 500
            implicitWidth: 500
            model: categoryModel
            textRole: "category"
        }

        ChartView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            animationOptions: ChartView.AllAnimations
            antialiasing: true

            ScatterSeries {
                name: "category"
                axisX: mapper.axisX
                axisY: mapper.axisY

                MyVXYModelMapper {
                    id: mapper
                    model: amountModel
                    xColumn: 0
                    yColumn: 1
                    firstRow: 0
                    rowCount: model.rowCount
                }
            }
        }
    }
}
