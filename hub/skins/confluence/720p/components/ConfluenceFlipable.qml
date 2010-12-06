import QtQuick 1.0

Flipable {
    id: root

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

    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180; }
        when: root.flipped == true
    }
}

