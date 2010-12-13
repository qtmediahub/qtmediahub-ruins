import QtQuick 1.0

Item {
    property variant itemdata : model
    property alias column1Text : column1.text
    property alias column2Text : column2.text

    width: ListView.view.width
    height: column1.height + 8
    Image {
        id: backgroundImage
        anchors.fill: parent;
        source: themeResourcePath + "/media/" + (ListView.isCurrentItem ? "MenuItemFO.png" : "MenuItemNF.png");
    }
    Row {
        spacing: 4
        Text {
            id: column1
            anchors.verticalCenter: parent.verticalCenter
            z: 1 // ensure it is above the background
            font.bold: true
            color: "blue"
            horizontalAlignment: Text.AlignRight
            width: 150 // ##
        }
        Text {
            text: ":"
            color: "lightgray"
        }
        Text {
            id: column2
            anchors.verticalCenter: parent.verticalCenter
            z: 1
            color: "white"
        }
    }

    MouseArea {
        anchors.fill: parent;
        hoverEnabled: true
        onEntered:
            ListView.view.currentIndex = index
    }
}

