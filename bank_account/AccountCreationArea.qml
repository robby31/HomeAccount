import QtQuick 2.5
import QtQuick.Controls 2.1

Item {
    width: column.width*1.2
    height: column.height*1.2

    property alias name: accountName.text
    property alias number: accountNumber.text

    Column {
        id: column
        spacing: 20
        anchors.margins: 10

        Row {
            id: rowName
            spacing: 5
            height: nameText.height

            Text {
                id: nameText
                text: "Name:"
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: accountName
                width: 200
                placeholderText: "account name"
            }
        }

        Row {
            id: rowNumber
            spacing: 5
            height: numberText.height

            Text {
                id: numberText
                text: "Number:"
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: accountNumber
                width: 200
                placeholderText: "account number"
            }
        }
    }
}

