import QtQuick 2.0
import QtQuick.Controls 1.2
import MyComponents 1.0

TableView{
    id: tableview

    TableViewColumn {
        role: "id"
        title: "ID"
        width: 120
    }
    TableViewColumn {
        role: "account_id"
        title: "Account"
        width: 120
    }
    TableViewColumn {
        role: "date"
        title: "Date"
        width: 120
        delegate: EditableCalendarDelegate { }
    }
    TableViewColumn {
        role: "payee"
        title: "Payee"
        width: 300
        delegate: EditableTextFieldDelegate { }
    }
    TableViewColumn {
        role: "memo"
        title: "Memo"
        width: 300
        delegate: EditableTextFieldDelegate { }
    }
    TableViewColumn {
        role: "category"
        title: "Category"
        width: 200
        delegate: EditableComboBoxDelegate { comboModel: categoryModel; comboTextRole: "category" }
    }
    TableViewColumn {
        role: "status"
        title: "Status"
        width: 120
        delegate: EditableComboBoxDelegate { comboModel: statusModel; comboTextRole: "text" }
    }
    TableViewColumn {
        role: "amount"
        title: "Amount"
        width: 200
        delegate: EditableDoubleDelegate { }
    }

    TableViewColumn {
        role: "balance"
        title: "Balance"
        width: 120
        delegate: Text { text: Number(styleData.value).toLocaleString(Qt.locale()) }
    }
}
