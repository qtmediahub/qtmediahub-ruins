import QtQuick 1.0

Item {
    width: text.width + 30
    height: 45

    BorderImage {
        anchors.fill: parent
        source: themeResourcePath + "/media/header.png"
        border.left: 32
    }

    Text {
        id: text
        text: "<b style=\"color:'gray'\">" + Qt.formatDateTime(backend.currentDateTime, "dddd, MMMM, yyyy") + " <b> | " 
              + "<b style=\"color:'white'\">" + Qt.formatDateTime(backend.currentDateTime, "hh:mm:ss AP")
        font.pointSize: 14
    }
}

