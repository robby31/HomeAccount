import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import MyComponents 1.0

ListViewDelegate {
    id: delegate

    height: delegate.ListView.isCurrentItem ? 35 : 22

    property string unit: "€"
    property int fontSize: delegate.ListView.isCurrentItem ? 14 : 10
    property color textColor: model["balance"] < 0 ? "red" : "black"

    swipe.right: Label {
        id: deleteLabel
        text: qsTr("Delete")
        color: "white"
        verticalAlignment: Label.AlignVCenter
        padding: 12
        height: parent.height
        anchors.right: parent.right

        SwipeDelegate.onClicked: {
            delegate.ListView.view.model.remove(index)
            swipe.close()
        }

        background: Rectangle {
            color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
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
                text: Date.fromLocaleString(Qt.locale(), model["date"], "yyyy-MM-dd").toLocaleDateString(Qt.locale(), "ddd dd MMM yyyy")
                elide: Text.ElideRight
                color: delegate.textColor
                clip: true
            }

            EditableText {
                id: transactionPayee
                anchors.verticalCenter: parent.verticalCenter
                width: 300
                height: delegate.height
                text: model["payee"]
                color: delegate.textColor
                font.pointSize: delegate.fontSize
                onEditingFinished: model["payee"] = text
                clip: true
            }

            EditableText {
                id: transactionMemo
                anchors.verticalCenter: parent.verticalCenter
                width: 400
                height: delegate.height
                text: model["memo"]
                color: delegate.textColor
                font.pointSize: delegate.fontSize
                onEditingFinished: model["memo"] = text
            }

            EditableComboBox {
                id: transactionCategory
                anchors.verticalCenter: parent.verticalCenter
                width: 300
                height: delegate.height
                comboModel: categoryModel
                textRole: "category"
                color: delegate.textColor
                fontSize: delegate.fontSize
                initValue: model["category"]
                onTextUpdated: model["category"] = currentText
            }

            EditableText {
                id: transactionAmount
                anchors.verticalCenter: parent.verticalCenter
                width: 130
                height: delegate.height
                text: Number(model["amount"]).toLocaleString(Qt.locale())
                color: delegate.textColor
                font.pointSize: delegate.fontSize
                validator: DoubleValidator { decimals: 2; notation: DoubleValidator.StandardNotation }
                onEditingFinished: model["amount"] = Number.fromLocaleString(Qt.locale(), text)
            }

            EditableComboBox {
                id: transactionStatus
                anchors.verticalCenter: parent.verticalCenter
                width: 130
                height: delegate.height
                comboModel: statusModel
                textRole: "text"
                color: delegate.textColor
                fontSize: delegate.fontSize
                initValue: model["status"]
                onTextUpdated: model["status"] = currentText
            }

            Row
            {
                anchors.verticalCenter: parent.verticalCenter
                height: delegate.height
                Layout.fillWidth: true
                layoutDirection: Qt.RightToLeft
                spacing: 10

                Image {
                    id: arrow
                    source: "../images/arrow.png"
                    width: height
                    height: delegate.height/2
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: model["is_split"] === "1" ? 1.0 : 0.0
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
                }
            }
        }
    }
}
