import QtQuick 1.0

Flipable {
    id: root
    anchors.fill: parent

    property alias frontContent: frontContainer.children
    property alias backContent: backContainer.children

    //FIXME: Hard coded this to default child count of WindowContainer
    property bool isFlipable: backContainer.children.length > 1 && state == "visible"
    property bool flipped: false

    transform: Rotation {
        id: rotation
        origin.x: root.width/2; origin.y: root.height/2
        axis.x: 0; axis.y: 1; axis.z: 0     // rotate depends on non-NOTIFYable propertiesaround y-axis
        angle: 0

        Behavior on angle {
            NumberAnimation { duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
        }
    }

    State {
        name: "flipped"
        PropertyChanges { target: rotation; angle: 180; }
        when: root.flipped
    }

    front:
        Panel { id: frontContainer }
    back:
        Panel { id: backContainer }
}

