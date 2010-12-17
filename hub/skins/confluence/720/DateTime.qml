import QtQuick 1.0

Item {
    width: 375
    height: 32

    BorderImage {
        anchors.fill: parent
        source: themeResourcePath + "/media/header.png"
        border.left: 32
        smooth: true
        transform: Rotation {
            angle: 180
            axis { x: 0; y: 1; z: 0 }
            origin { x: width/2; y: height/2 }
        }
    }

    Text {
        x: 40
        id: text
        text: "<span style=\"color:'gray'\">" + Qt.formatDateTime(backend.currentDateTime, "dddd, MMMM, yyyy") + " </span> " 
              + "<span style=\"color:'white'\"> | " + Qt.formatDateTime(backend.currentDateTime, "hh:mm:ss AP") + "</span>"
        font.pointSize: 14
    }
}

