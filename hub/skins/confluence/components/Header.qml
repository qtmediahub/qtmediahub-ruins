import QtQuick 1.0

Item {
    height: 32
    property int leftBorder: 0
    property int rightBorder : 200

    property bool flip : true

    BorderImage {
        anchors.fill: parent
        source: themeResourcePath + "/media/header.png"
        border.left: leftBorder
        border.right: rightBorder
        smooth: true
        transform: Rotation {
            angle: flip ? 180 : 0
            axis { x: 0; y: 1; z: 0 }
            origin { x: width/2; y: height/2 }
        }
    }
}


