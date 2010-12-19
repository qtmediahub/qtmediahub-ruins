import QtQuick 1.0

Item {
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
}


