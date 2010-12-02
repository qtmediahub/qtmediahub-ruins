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

    property bool isFlipable: false//state == "visible"
    property bool flipped: false

    property int marginOffset: 20
    property int defaultWidth: 1024
    property int defaultHeight: 512
    property int maximizedWidth: parent.width + 2*marginOffset
    property int maximizedHeight: parent.height + 2*marginOffset

    width: defaultWidth; height: defaultHeight

    property alias front: flipable.front
    property alias back: flipable.back

    property alias defaultDecoration: frame.visible
    property alias defaultTitleBar: frameTitle.visible

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
        //All future children silently reparented to front
        for (var i = 0; i < children.length; ++i)
            children[i] != flipable ? children[i].parent = flipable.front : 0
    }

    Component.onCompleted:
        //Tried binding but (back != null) is not notifiable?
        isFlipable = (root.back != null)

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
            FocusScope {
            focus: true
            anchors.fill: parent

            BorderImage {
                id: frame
                source: themeResourcePath + "/media/ContentPanel.png"
                anchors.fill: parent
                border { left: 30; top: 30; right: 30; bottom: 30 }
            }

            // This is a child of the frame but written as a top-level child only
            // to expose the frameTitle.visible property
            BorderImage {
                id: frameTitle
                parent: frame
                source: themeResourcePath + "/media/GlassTitleBar.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:  parent.top
                anchors.topMargin: 10
            }
        }
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
