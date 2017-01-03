import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import MyComponents 1.0

Item {
    id: delegate
    width: parent.width
    height: delegate.ListView.isCurrentItem ? 40 : item.height + 10
    clip: true

    property string unit: "€"
    property int fontSize: delegate.ListView.isCurrentItem ? 14 : 10
    property color textColor: model["balance"] < 0 ? "red" : "black"

    Rectangle {
        id: hover
        anchors.fill: parent
        color: theme.hoverColor
        visible: mouseArea.containsMouse
    }

    Rectangle {
        id: highlight
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.highlightGradientStart }
            GradientStop { position: 1.0; color: theme.highlightGradientEnd }
        }

        visible: mouseArea.pressed || delegate.ListView.isCurrentItem

        onVisibleChanged: {
            if (visible) {
                transactionCategory.sourceComponent = paramEditable
                transactionStatus.sourceComponent = paramEditable
            } else {
                transactionCategory.sourceComponent = paramReadOnly
                transactionStatus.sourceComponent = paramReadOnly
            }
        }
    }

    Item {
        id: item

        height: row.height

        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        RowLayout {
            id: row
            width: parent.width
            spacing: 10

            Text {
                id: transactionDate
                Layout.preferredWidth: 150
                Layout.preferredHeight: contentHeight
                font.pointSize: delegate.fontSize
                text: Date.fromLocaleString(Qt.locale(), model["date"], "yyyy-MM-dd").toLocaleDateString(Qt.locale(), "ddd dd MMM yyyy")
                elide: Text.ElideRight
                color: delegate.textColor
            }

            Text {
                id: transactionPayee
                Layout.preferredWidth: 300
                Layout.preferredHeight: contentHeight
                font.pointSize: delegate.fontSize
                text: model["payee"]
                elide: Text.ElideRight
                color: delegate.textColor
            }

            Text {
                id: transactionMemo
                Layout.preferredWidth: 400
                Layout.preferredHeight: contentHeight
                font.pointSize: delegate.fontSize
                text: model["memo"]
                elide: Text.ElideRight
                color: delegate.textColor
            }

            Loader {
                id: transactionCategory
                Layout.preferredWidth: 300
                sourceComponent: paramReadOnly

                property string value: model["category"]
                property var comboModel: categoryModel
                property string comboTextRole: "category"
                property bool comboEditable: true

                function valueUpdated(value) {
                    model["category"] = value
                }
            }


            Text {
                id: transactionAmount
                Layout.preferredWidth: 100
                Layout.preferredHeight: contentHeight
                font.pointSize: delegate.fontSize
                text: "%1 %2".arg(Number(model["amount"]).toLocaleString(Qt.locale())).arg(delegate.unit)
                elide: Text.ElideRight
                color: delegate.textColor
            }

            Loader {
                id: transactionStatus
                Layout.preferredWidth: 120
                sourceComponent: paramReadOnly

                property string value: model["status"]
                property var comboModel: statusModel
                property string comboTextRole: "text"
                property bool comboEditable: false

                function valueUpdated(value) {
                    model["status"] = value
                }
            }

            Row
            {
                Layout.fillWidth: true
                layoutDirection: Qt.RightToLeft
                spacing: 10

                Image {
                    id: arrow
                    source: "../images/arrow.png"
                    width: height
                    height: delegate.height/2
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: model["is_split"] === "1" ? 1.0 : 0.5
                }

                Text {
                    id: transactionBalance
                    width: contentWidth
                    font.pointSize: delegate.fontSize
                    text: "%1 %2".arg(Number(model["balance"]).toLocaleString(Qt.locale())).arg(delegate.unit)
                    color: delegate.textColor
                }
            }
        }
    }

    Component {
        id: paramReadOnly

        Text {
            text: value
            elide: Text.ElideRight
            color: textColor
        }
    }

    Component {
        id: paramEditable

        ComboBox {
            model: comboModel
            textRole: comboTextRole
            editable: comboEditable
            focus: true

            property bool toUpdate: false

            Component.onCompleted: {
                var index = find(value)
                if (index !== -1 && index !== currentIndex)
                    currentIndex = index
            }

            onCurrentIndexChanged: {
                if (toUpdate)
                    valueUpdated(currentText)
                toUpdate = false
            }

            onActivated: toUpdate = true

            onAccepted: valueUpdated(currentText)
        }
    }

    Rectangle {
        id: separatorBottom
        width: parent.width
        height: 1
        anchors { left: parent.left; bottom: parent.bottom }
        color: theme.separatorColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: delegate.ListView.view.selectTransaction(index)
        visible: !delegate.ListView.isCurrentItem
    }
}

