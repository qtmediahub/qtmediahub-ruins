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
        property string plainCurrentTime: Qt.formatDateTime(backend.currentDateTime, "hh:mm:ss AP")
        property string plainCurrentDateTime: Qt.formatDateTime(backend.currentDateTime, "dddd, MMMM, yyyy") + " | "
                                              + plainCurrentTime
        id: shadowText
        x: root.showDate ? 41 : 21;
        y: 1
        font.pointSize: 14
        color: "black"
        text: showDate ? plainCurrentDateTime : plainCurrentTime
    }

    Text {
        x: root.showDate ? 40 : 20
        id: text // same as the property?
        text: showDate ? currentDateTime() : currentTime()
        font.pointSize: 14
    }
}

