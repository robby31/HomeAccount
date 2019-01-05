import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import MyComponents 1.0

ColumnLayout {
    id: accountsList
    spacing: 10

    property alias model: listAccounts.model

    Row {
        Layout.preferredWidth: parent.width - 20
        Layout.preferredHeight: 40
        Layout.alignment: Qt.AlignHCenter

        Button {
            anchors.verticalCenter: parent.verticalCenter
            height: 20
            text: "+ New Account"
            onClicked: drawer.open()
        }
    }

    ListView {
        id: listAccounts

        Layout.fillWidth: true
        Layout.fillHeight: true

        signal selectAccount(int id, string name)

        delegate: AccountsDelegate { }
        focus: true
        highlightFollowsCurrentItem: false
        clip: true

        ScrollBar.vertical: ScrollBar { }

        onSelectAccount: selectAccountforTransactions(id, name)
    }

    Drawer {
        id: drawer
        width: parent.width
        height: creationArea.height + 20
        edge: Qt.BottomEdge

        AccountCreationArea {
            id: creationArea

            anchors { verticalCenter: parent.verticalCenter ; horizontalCenter: parent.horizontalCenter }

            onCreate_account: {
                listAccounts.model.createAccount(name, number)
                drawer.close()
            }

            onCancel: drawer.close()
        }
    }
}
