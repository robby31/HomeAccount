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
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            anchors.verticalCenter: parent.verticalCenter
            height: 20
            text: "+ New Account"
            onClicked: accountcreationDialog.open()
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

    AccountCreationDialog {
        id: accountcreationDialog
    }

}
