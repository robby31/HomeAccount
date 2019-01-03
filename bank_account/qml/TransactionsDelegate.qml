import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import MyComponents 1.0

ListViewDelegate {
    id: delegate

    height: delegate.ListView.isCurrentItem ? 35 : 22

    property string unit: "€"
    property int fontSize: delegate.ListView.isCurrentItem ? 14 : 10
    property color textColor: model["balance"] < 0 ? "red" : "black"
    property bool splitEnabled: false

    swipe.right: Row {
        height: parent.height
        anchors.right: parent.right
        spacing: 0

        Label {
            id: deleteLabel
            text: qsTr("Delete")
            color: "white"
            verticalAlignment: Label.AlignVCenter
            padding: 12
            height: parent.height

            SwipeDelegate.onClicked: {
                delegate.ListView.view.model.remove(index)
            }

            background: Rectangle {
                color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
            }
        }

        Label {
            id: splitLabel
            text: qsTr("Split")
            color: "white"
            verticalAlignment: Label.AlignVCenter
            padding: 12
            height: parent.height
            visible: splitEnabled

            SwipeDelegate.onClicked: {
                selectDetails(model["id"], amount, date)
                swipe.close()
            }

            background: Rectangle {
                color: splitLabel.SwipeDelegate.pressed ? Qt.darker("grey", 1.1) : "grey"
            }
        }
    }

    contentItem: Item {
        Row {
            anchors.fill: parent
            spacing: 10

            Text {
                id: transactionDate
                anchors.verticalCenter: parent.verticalCenter
                width: 150
                height: delegate.height
                verticalAlignment: Text.AlignVCenter
                font.pointSize: delegate.fontSize
                text: Date.fromLocaleString(Qt.locale(), date, "yyyy-MM-dd").toLocaleDateString(Qt.locale(), "ddd dd MMM yyyy")
                elide: Text.ElideRight
                color: delegate.textColor
                clip: true
            }

            ModelEditableText {
                id: transactionPayee
                anchors.verticalCenter: parent.verticalCenter
                width: 300
                height: delegate.height
                text: payee
                placeholderText: "payee"
                color: delegate.textColor
                font.pointSize: delegate.fontSize
                onEditingFinished: {
                    payee = text
                }
                clip: true
            }

            ModelEditableText {
                id: transactionMemo
                anchors.verticalCenter: parent.verticalCenter
                width: 400
                height: delegate.height
                text: memo
                placeholderText: "memo"
                color: delegate.textColor
                font.pointSize: delegate.fontSize
                onEditingFinished: {
                    memo = text
                }
            }

            ModelEditableComboBox {
                id: transactionCategory
                anchors.verticalCenter: parent.verticalCenter
                width: 300
                height: delegate.height
                font { pointSize: delegate.fontSize }
                color: delegate.textColor
                editable: true

                isCurrentItem: delegate.ListView.isCurrentItem
                placeholderText: "<no category>"
                modelText: category
                model: categoryModel
                textRole: "category"

                onUpdateModelText: {
                    category = text
                    categoryModel.reload()
                }

            }

            ModelEditableText {
                id: transactionAmount
                anchors.verticalCenter: parent.verticalCenter
                width: 130
                height: delegate.height
                font { pointSize: delegate.fontSize }
                color: delegate.textColor

                text: Number(amount).toLocaleString(Qt.locale())
                placeholderText: "amount"
                validator: DoubleValidator { decimals: 2; notation: DoubleValidator.StandardNotation }
                onEditingFinished: {
                    amount = Number.fromLocaleString(Qt.locale(), text)
                }
            }

            ModelEditableComboBox {
                id: transactionStatus
                anchors.verticalCenter: parent.verticalCenter
                width: 130
                height: delegate.height
                font { pointSize: delegate.fontSize }
                color: delegate.textColor

                isCurrentItem: delegate.ListView.isCurrentItem
                placeholderText: "<no status>"
                modelText: status
                model: statusModel
                textRole: "value"

                onUpdateModelText: {
                    status = text
                }
            }

            Row
            {
                anchors.verticalCenter: parent.verticalCenter
                height: delegate.height
                Layout.fillWidth: true
                layoutDirection: Qt.RightToLeft
                spacing: 10

                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: arrowComponent
                }

                Text {
                    id: transactionBalance
                    width: contentWidth
                    height: delegate.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: delegate.fontSize
                    text: "%1 %2".arg(Number(model["balance"]).toLocaleString(Qt.locale())).arg(delegate.unit)
                    color: delegate.textColor
                    clip: true
                    visible: model["balance"] !== undefined
                }
            }
        }
    }

    Component {
        id: arrowComponent

        Item {
            id: item
            width: arrow.width
            height: arrow.height

            Image {
                id: arrow
                source: "../images/arrow.png"
                width: height
                height: delegate.height/2
                anchors.verticalCenter: parent.verticalCenter
                opacity: is_split === "1" ? 1.0 : 0.0

                MouseArea {
                    id: arrowMouseArea
                    anchors.fill: parent
                    onClicked: selectDetails(model["id"], amount, date)
                }
            }

            Colorize {
                anchors.fill: arrow
                source: arrow
                hue: 0.0
                saturation: 0.5
                lightness: 1.0
                visible: arrowMouseArea.pressed
            }
        }
    }
}
