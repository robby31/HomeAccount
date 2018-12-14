import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import MyComponents 1.0

Page {
    id: home
    width: 200
    height: 100

    actions: accountsPageActions

    onActionClicked: {
        if (name == "Quit")
            Qt.quit()
    }

    ListModel {
        id: accountsPageActions

        ListElement {
            name: "Quit"
            description: "Exit application"
            icon: "qrc:///images/exit.png"
        }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 20

        Column {
            id: column1
            spacing: 30
            Layout.preferredWidth: 200
            Layout.preferredHeight: newButton.height+openButton.height+spacing
            Layout.alignment: Qt.AlignVCenter

            MyButton {
                id: newButton
                width: 100

                anchors { horizontalCenter: parent.horizontalCenter }

                sourceComponent: Text { text: "New" }

                onButtonClicked: {
                    openDialog.selectExisting = false
                    openDialog.open()
                }
            }

            MyButton {
                id: openButton
                width: 100

                anchors { horizontalCenter: parent.horizontalCenter }

                sourceComponent: Text { text: "Open" }

                onButtonClicked: {
                    openDialog.selectExisting = true
                    openDialog.open()
                }
            }
        }

        ColumnLayout
        {
            id: column2
            Layout.fillWidth: true
            spacing: 10

            Text {
                id: textHeader
                Layout.preferredWidth: contentWidth
                Layout.preferredHeight: contentHeight
                text: "Recent files"
                font.pointSize: 14
                font.bold: true
            }

            Rectangle {
                id: separatorBottom
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 1
                color: theme.separatorColor
            }

            ListView {
                id: recentfilesView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: _app.recentFiles
                delegate: RecentFilesDelegate { }

                function selectFile(fileUrl) {
                    _app.databaseName = fileUrl.replace(/^(file:\/{2})/,"")
                }
            }
        }
    }

    FileDialog {
        id: openDialog
        nameFilters: [ "Bank account (*.sql)" ]
        onAccepted: _app.databaseName = fileUrl.toString().replace(/^(file:\/{2})/,"")
    }
}
