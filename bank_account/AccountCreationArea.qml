import QtQuick 2.5
import QtQuick.Controls 2.1

Item {
    id: item1
    width: column.width*1.2
    height: column.height*1.2

    property alias name: accountName.text
    property alias number: accountNumber.text

    Column {
        id: column
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        anchors.margins: 10

        Row {
            id: rowName
            spacing: 5

            Text {
                id: nameText
                text: "Name:"
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: accountName
                width: 200
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: "account name"
            }
        }

        Row {
            id: rowNumber
            spacing: 5

            Text {
                id: numberText
                text: "Number:"
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: accountNumber
                width: 200
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: "account number"
            }
        }
    }
}

