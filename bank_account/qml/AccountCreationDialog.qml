import QtQuick 2.5
import QtQuick.Dialogs 1.2

Dialog {
    id: dialog

    width: item.width*1.2
    height: item.height*2.0

    title: "Account creation"

    standardButtons: StandardButton.Ok | StandardButton.Cancel

    AccountCreationArea {
        id: item
        anchors { verticalCenter: parent.verticalCenter }
    }

    onAccepted: create_account(item.name, item.number)
}
