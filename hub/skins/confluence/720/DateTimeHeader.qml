import QtQuick 1.0

Item {
    id: root
    property bool showDate: true
    width: text.x + text.width + 10
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

    function currentTime() {
              return "<span style=\"color:'white'\">" + Qt.formatDateTime(backend.currentDateTime, "hh:mm:ss AP") + "</span>"
    }

    function currentDateTime() {
        return "<span style=\"color:'gray'\">" + Qt.formatDateTime(backend.currentDateTime, "dddd, MMMM, yyyy") + " </span> " 
               + "<span style=\"color:'white'\"> | </span>"
               + currentTime()
 
    }

    Text {
        x: root.showDate ? 40 : 20
        id: text
        text: showDate ? currentDateTime() : currentTime()
        font.pointSize: 14
    }
}

