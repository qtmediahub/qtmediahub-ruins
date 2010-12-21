import QtQuick 1.0
import "../components/"

Header {
    id: root
    property bool showDate: true
    width: text.x + text.width + 10

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
