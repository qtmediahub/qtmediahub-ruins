import QtQuick 1.0

ListView {
    id: flickable

    BorderImage {
        id: scrollbar
        height: flickable.height
        anchors.right: flickable.right

        source: themeResourcePath + "/media/ScrollBarV.png"
        border { top: 14; right: 0; bottom: 14; left: 0; }
        width: 24

        BorderImage {
            id: slider
            width: scrollbar.width
            y: flickable.visibleArea.yPosition * scrollbar.height
            height: flickable.visibleArea.heightRatio * scrollbar.height
            source: themeResourcePath + "/media/ScrollBarV_bar.png"
            border { top: 14; right: 0; bottom: 14; left: 0; }
        }
    }
}

