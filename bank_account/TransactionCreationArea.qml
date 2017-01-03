import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    width: column.width
    height: calendar.height

    signal create_transaction(date date, string payee, string memo, string amount)

    Row {
        Calendar {
            id: calendar
        }

        Column {
            id: column
            spacing: 10

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
                onClicked: create_transaction(calendar.selectedDate, payee.text, memo.text, amount.text)
            }
        }
    }
}

