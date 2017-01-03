import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import MyComponents 1.0

Item {
    id: delegate
    width: parent.width
    height: accountItem.height*1.2
    clip: true

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
        visible: mouseArea.pressed
    }

    Item {
        id: accountItem

        height: accountText.height

        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        RowLayout {
            id: accountText
            width: parent.width
            spacing: 10

            Text {
                id: accountTextId
                Layout.preferredWidth: 50
                font.pointSize: 14
                text: model["id"]
                elide: Text.ElideRight
            }

            Text {
                id: accountTextName
                Layout.preferredWidth: 200
                font.pointSize: 14
                text: model["name"]
                elide: Text.ElideRight
            }

            Text {
                id: accountTextNumber
                Layout.preferredWidth: 200
                font.pointSize: 14
                text: model["number"]
                elide: Text.ElideRight
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
                }

                Text {
                    id: accountTextAmount
                    width: contentWidth
                    font.pointSize: 14
                    text: Number(model["amount"]).toLocaleString(Qt.locale()) + " euros"
                }
            }
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
        onClicked: delegate.ListView.view.selectAccount(model["id"], model["name"])
    }
}

