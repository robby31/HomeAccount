import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import MyComponents 1.0

ColumnLayout {
    id: accountsList
    spacing: 10

    property alias model: listAccounts.model

    Row {
        Button {
            text: "New Account"
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

        ScrollIndicator {
            id: scrollIndicator
            width: 10
            height: parent.height
            anchors {top: parent.top; right: parent.right}
            handleSize: height > 0 ? listAccounts.visibleArea.heightRatio * height : 0
            handlePosition: height > 0 ? listAccounts.visibleArea.yPosition * height : 0
            opacity: listAccounts.moving? 1.0 : 0.0
        }

        onSelectAccount: selectAccountforTransactions(id, name)
    }

    AccountCreationDialog {
        id: accountcreationDialog
    }

}
