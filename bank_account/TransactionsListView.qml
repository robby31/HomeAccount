import QtQuick 2.5
import QtQuick.Controls 2.1

ListView {
    id: listview

    property string unit: "€"

    clip: true

    delegate: TransactionsDelegate { unit: listview.unit }

    focus: true

    ScrollBar.vertical: ScrollBar { }
}
