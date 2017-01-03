import QtQuick 2.6
import QtQuick.Controls 2.0

ComboBox {
    id: combo

    property color textColor: "black"
    property int fontSize: 12
    property bool editable: true

    delegate: ItemDelegate {
        width: combo.width
        height: 25
        contentItem: Text {
            text: modelData
            color: combo.textColor
            font.pointSize: combo.fontSize
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: combo.highlightedIndex == index
    }

    contentItem: Text {
        leftPadding: 0
        rightPadding: combo.indicator.width + combo.spacing

        text: combo.displayText
        font.pointSize: combo.fontSize
        color: combo.textColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    indicator: Canvas {
        id: canvas
        x: combo.width - width - combo.rightPadding
        y: combo.topPadding + (combo.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"
        visible: combo.editable

        Connections {
            target: combo
            onPressedChanged: canvas.requestPaint()
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = "black"
            context.fill();
        }
    }

    background: Rectangle {
        border.color: "black"
        border.width: combo.visualFocus ? 2 : 1
        radius: 2
        visible: combo.editable
    }

//    popup: Popup {
//        y: comboStatus.height - 1
//        width: comboStatus.width
//        implicitHeight: listview.contentHeight
//        padding: 1

//        contentItem: ListView {
//            id: listview
//            clip: true
//            model: comboStatus.popup.visible ? comboStatus.delegateModel : null
//            currentIndex: comboStatus.highlightedIndex

////            ScrollIndicator.vertical: ScrollIndicator { }
//        }

//        background: Rectangle {
//            border.color: "black"
//            radius: 2
//        }
//    }
}
