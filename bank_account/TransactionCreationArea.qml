import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    width: 500
    height: 300

    property date parent_date

    signal create_transaction(date date, string payee, string memo, string amount)

    Row {
        id: row
        spacing: 50
        anchors.fill: parent

        Calendar {
            id: calendar
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            weekNumbersVisible: false
            visible: parent_date.toString() == "Invalid Date"
        }

        Column {
            id: column
            spacing: 20

            Row {
                id: rowPayee
                spacing: 5
                height: payeeText.height

                Text {
                    id: payeeText
                    text: "Payee:"
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: payee
                    width: 200
                    placeholderText: "payee name"
                }
            }

            Row {
                id: rowMemo
                spacing: 5
                height: memoText.height

                Text {
                    id: memoText
                    text: "Memo:"
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: memo
                    width: 200
                    placeholderText: "memo text"
                }
            }

            Row {
                id: rowAmount
                spacing: 5
                height: amountText.height

                Text {
                    id: amountText
                    text: "Amount:"
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: amount
                    width: 200

                    validator: DoubleValidator {
                        decimals: 2
                        notation: DoubleValidator.StandardNotation
                    }
                }
            }

            Button {
                id: creationButton
                text: "create"
                enabled: payee.text != ""
                onClicked: {
                    if (parent_date.toString() == "Invalid Date")
                        create_transaction(calendar.selectedDate, payee.text, memo.text, Number.fromLocaleString(Qt.locale(), amount.text))
                    else
                        create_transaction(parent_date, payee.text, memo.text, Number.fromLocaleString(Qt.locale(), amount.text))
                }
            }
        }
    }
}

