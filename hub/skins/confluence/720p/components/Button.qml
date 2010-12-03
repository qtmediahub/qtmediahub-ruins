import QtQuick 1.0

Image {
    id: root
    property alias text: textLabel.text
    signal clicked()

    width: 80
    height: textLabel.height
    source: themeResourcePath + "/media/" + (mouseArea.pressed ? "button-focus.png" : "button-nofocus.png")

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Text {
        id: textLabel
        anchors.centerIn: parent
        color: "blue"
    }
}

