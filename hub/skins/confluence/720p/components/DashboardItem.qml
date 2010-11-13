import QtQuick 1.0

Image {
    id: viewport
    clip: true
    height: item.height + 40
    width: item.width + 40

    fillMode: Image.Stretch
    source: themeResourcePath + "/media/ContentPanel.png"

    property alias container: item

    MouseArea {
        anchors.fill: parent
        drag.target: viewport
    }

    Item {
        id: item
        clip: true
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }
}
