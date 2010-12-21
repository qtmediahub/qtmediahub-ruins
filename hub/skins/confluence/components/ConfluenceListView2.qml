import QtQuick 1.0

ListView {
    id: list
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
            width: parent.width-4
            height: parent.height
            opacity: 0

        }

        ConfluenceText {
            id: delegateText
            font.pointSize: 16
            text: model.name
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: delegateImage.left
            anchors.leftMargin: 10
        }

        ConfluenceText {
            id: delegateValue
            font.pointSize: 16
            text: model.options ? model.options.split(",")[model.currentOption] : ""
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: delegateImage.right
            anchors.rightMargin: 10
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
                NumberAnimation { target: delegateImage; property: "opacity"; duration: 100 }
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
                var options = model.options.split(",")
                list.model.setProperty(index, "currentOption", (currentOption+1)%options.length)
                delegate.trigger()
            }
        }

        function trigger() {
            // do stuff
        }
    }
}

