import QtQuick 1.0
import "components"

Dialog {
    id: root

    property variant startupAnimationComponent

    onVisibleChanged: {
        if(visible == true) {
            startupAnimationComponent = Qt.createComponent(generalResourcePath + "/qml-startup/startup.qml")
            if(startupAnimationComponent.status == Component.Ready)
                back = startupAnimationComponent.createObject(root)
        } else {
            startupAnimationComponent.destroy()
            back.destroy()
            back = startupAnimationComponent.createObject(root)
        }
    }

    Flow {
        anchors.centerIn: parent
        //width: childrenRect.width; height: childrenRect.height
        flow:  Flow.TopToBottom
        Item {
            width: childrenRect.width; height: childrenRect.height
            ConfluenceText { id: confTxt; text: qsTr("All resources and style from ") }
            Image {
                anchors { left: confTxt.right; verticalCenter: confTxt.verticalCenter }
                source: themeResourcePath + "/media/Confluence_Logo.png"
            }
        }
        Item {
            width: childrenRect.width; height: childrenRect.height
            ConfluenceText { id: xbmcTxt; text: qsTr("Inspired by ") }
            Image {
                anchors { left: xbmcTxt.right; verticalCenter: xbmcTxt.verticalCenter }
                source: themeResourcePath + "/media/XBMC_Logo.png"
            }
        }
        ConfluenceText { text: "http://xbmc.org/"}
        ConfluenceText { text: "QtMediaCenter is hosted at http://gitorious.org/qtmediahub"}
    }

    PropertyAnimation on angle {
        loops: Animation.Infinite
        duration: 10000
        from: 0
        to: 360
    }
}
