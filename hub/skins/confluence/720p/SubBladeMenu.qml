import QtQuick 1.0
import "components"

FocusScope {
    id: root

    property alias model : list.model

    ListView {
        id: list
        anchors.fill: parent
        keyNavigationWraps: true

        Keys.onEnterPressed:
            currentItem.trigger()

        delegate: Item {
            id: delegate
            anchors.right: parent.right
            transformOrigin: Item.Right
            width: parent.width
            height: delegateText.height + 20
            focus: true

            Image {
                id: delegateBackground
                source: themeResourcePath + "/media/button-nofocus.png"
                anchors.fill: parent
            }

            Image {
                id: delegateImage
                source: themeResourcePath + "/media/button-focus.png"
                anchors.centerIn: parent
                width: parent.width-2
                height: parent.height
                opacity: 0

            }

            ConfluenceText {
                id: delegateText
                font.pointSize: 16
                text: model.modelData.name
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            states:  [
                State {
                    name: "selected"
                    when: list.currentIndex == index
                    PropertyChanges {
                        target: delegateImage
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation { target: delegateImage; property: "opacity"; duration: 200 }
                }
            ]

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    list.currentIndex = index
                    list.forceActiveFocus()
                }

                onClicked: {
                    delegate.trigger()
                }
            }

            function trigger() {
                // do stuff
            }
        }
    }
}
