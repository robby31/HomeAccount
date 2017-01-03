import QtQuick 2.0
import QtQuick.Controls 1.4

ListView {
    id: listview

    property string unit: "€"

    clip: true

    delegate: TransactionsDelegate { unit: listview.unit }

    function selectTransaction(index) {
        // update selection
        currentIndex = index
    }
}
