/****************************************************************************

This file is part of the QtMediaHub project on http://www.gitorious.org.

Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation (qt-info@nokia.com)**

You may use this file under the terms of the BSD license as follows:

"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

****************************************************************************/

import QtQuick 1.0

FocusScope {
    id: root
    clip: true

    z: 1
    anchors.centerIn: parent

    opacity: 0; visible: false
    scale: 0

    property int angle: 0

    property bool maximized: false
    property bool maximizable: false

    property alias frontContent: frontContainer.children
    property alias backContent: backContainer.children

    //FIXME: Hard coded this to default child count of WindowContainer
    property bool isFlipable: backContainer.children.length > 1 && state == "visible"
    property bool flipped: false

    property int marginOffset: 20
    property int defaultWidth: 984
    property int defaultHeight: 472
    property int maximizedWidth: parent.width + 2*marginOffset
    property int maximizedHeight: parent.height + 2*marginOffset

    width: defaultWidth + 2*marginOffset; height: defaultHeight + 2*marginOffset

    property alias defaultDecoration: frontContainer.decorateFrame
    property alias defaultTitleBar: frontContainer.decorateTitlebar

    //useful for focus debugging
    //onActiveFocusChanged: console.log(idtext + " just " + (activeFocus ? "got" : "lost") + " focus")

    onMaximizedChanged:
        confluence.state = root.maximized ? "showingSelectedElementMaximized" : "showingSelectedElement"

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                visible: true
                opacity: 1
                scale: 1
            }
        },
        State {
            name: "flipped"
            extend: "visible"
            PropertyChanges {
                target: root
                angle: 180
            }
        },
        State {
            name: "maximized"
            //when: maximized
            PropertyChanges {
                target: root
                visible: true
                opacity: 1
                scale: 1
                width: maximizedWidth
                height: maximizedHeight
            }
        }
    ]

    transitions: [
        Transition {
            to: ""
            SequentialAnimation {
                ScriptAction { script: onHideTransitionStarted() }
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
                    NumberAnimation { property: "scale"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
                }
                PropertyAction { target: root; property: "visible"; value: false }
            }
        },
        Transition {
            from: ""
            to: "visible"
            SequentialAnimation {
                PropertyAction { target: root; property: "visible"; value: true }
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
                    NumberAnimation { property: "scale"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
                }
                ScriptAction { script: onVisibleTransitionComplete() }
                ScriptAction { script: root.forceActiveFocus() }
            }
        }

    ]

    onChildrenChanged: {
        for (var i = 0; i < children.length; ++i) {
            //All future children silently reparented to front
            //by default
            var element = children[i];
            element != flipable ? children[i].parent = frontContainer : 0
        }
    }

    function onHideTransitionStarted() {
        //Any other way of extending generalized states/transitions?
    }
    function onVisibleTransitionComplete() {
        //Any other way of extending generalized states/transitions?
    }

    Flipable {
        id: flipable
        anchors.fill: parent

        transform: Rotation {
            origin.x: root.width/2; origin.y: root.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // rotate depends on non-NOTIFYable propertiesaround y-axis
            angle: root.angle
        }

        front:
            Panel { id: frontContainer }
        back:
            Panel { id: backContainer }
    }

    Behavior on angle {
        NumberAnimation { duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
    }

    Behavior on width {
        NumberAnimation { duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
    }

    Behavior on height {
        NumberAnimation { duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
    }
}
