import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: item
    width: calendar.width
    height: calendar.height

    property alias selectedDate: calendar.selectedDate
    property date parent_date

    Calendar {
        id: calendar
        weekNumbersVisible: false
        visible: parent_date.toString() == "Invalid Date"


        style: CalendarStyle {
            gridVisible: true

            navigationBar:
                Row {
                width: control.width
                anchors.centerIn: parent
                spacing: 0

                Button {
                    text: "<"
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 30
                            implicitHeight: 25
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
                    onClicked: control.showPreviousMonth()
                }

                Label {
                    width: control.width-60
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: styleData.title
                    color: "black"
                }

                Button {
                    text: ">"
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 30
                            implicitHeight: 25
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
                    onClicked: control.showNextMonth()
                }
            }

        }
    }

}
