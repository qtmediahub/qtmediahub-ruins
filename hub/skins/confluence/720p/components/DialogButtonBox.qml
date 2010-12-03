import QtQuick 1.0

Row {
    id: root
    signal accept()
    signal reject()

    Button {
        id: okButton
        text: qsTr("OK")
        onClicked: root.accept()
    }
    Button {
        id: cancelButton
        text: qsTr("Cancel")
        onClicked: root.reject()
    }
}

