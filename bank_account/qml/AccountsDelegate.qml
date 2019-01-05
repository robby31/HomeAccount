import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import MyComponents 1.0

ListViewDelegate {
    id: delegate

    clip: true

    onDoubleClicked: delegate.ListView.view.selectAccount(model["id"], model["name"])

    swipe.left: Row {
        anchors.left: parent.left
        height: parent.height

        Label {
            id: deleteLabel
            text: qsTr("Remove")
            color: "white"
            verticalAlignment: Label.AlignVCenter
            padding: 12
            height: parent.height

            SwipeDelegate.onClicked: {
                swipe.close()
                delegate.ListView.view.model.remove(index)
            }

            background: Rectangle {
                color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
            }
        }
    }

    contentItem: Item {
        id: accountItem
        width: parent.width

        RowLayout {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                Layout.preferredWidth: 50
                font.pointSize: 14
                text: model["id"] ? model["id"] : ""
                elide: Text.ElideRight
            }

            Text {
                Layout.preferredWidth: 200
                font.pointSize: 14
                text: model["name"] ? model["name"] : ""
                elide: Text.ElideRight
            }

            Text {
                Layout.preferredWidth: 200
                font.pointSize: 14
                text: model["number"] ? model["number"] : ""
                elide: Text.ElideRight
            }

            Row
            {
                Layout.fillWidth: true
                layoutDirection: Qt.RightToLeft
                spacing: 10

                Image {
                    source: "../images/arrow.png"
                    width: height
                    height: delegate.height/2
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    width: contentWidth
                    font.pointSize: 14
                    text: Number(model["amount"]).toLocaleString(Qt.locale()) + " euros"
                }
            }
        }
    }
}

