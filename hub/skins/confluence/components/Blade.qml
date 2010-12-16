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
    width: blade.width + blade.x; height: parent.height

    clip: true

    signal opened
    signal closed

    property bool windowingComponent: true
    property int closedBladePeek: 30

    property alias bladeVisibleWidth: blade.visibleWidth
    property alias bladeWidth: blade.width
    property alias bladePixmap: bladePixmap.source
    property alias bladeX: blade.x
    property alias bladeContent: content
    //pixmap specific offset (pixmap alpha!)
    property int bladeRightMargin: 30

    property variant visibleContent

    state:  "closed"

    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: blade
                clickToShow: true
                visibleWidth: root.closedBladePeek
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: blade
                clickToShow: false
                visibleWidth: 0
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: blade
                visibleWidth: width
            }
        }
    ]

    transitions: [
        Transition {
            to: "open"
            ScriptAction { script: forceActiveFocus() }
        }, Transition {
            to: "closed"
            ScriptAction { script: closed() }
        }
    ]

    onFocusChanged:
        if(activeFocus == false)
            state = "closed"

    onVisibleContentChanged:
        setCurrentContent(visibleContent)

    onChildrenChanged: {
        //Always want new content parented to content region
        for (var i = 0; i < children.length; ++i)
            children[i] != blade && !children[i].windowingComponent ? children[i].parent = content : 0
    }

    function setCurrentContent(contentName)
    {
        for(var i = 0; i < content.children.length; ++i)
        {
            var currentChild = content.children[i]
            if(currentChild == visibleContent)
                currentChild.visible = true
            else
                currentChild.visible = false
        }
    }

    Item {
        id: blade
        x: -width + visibleWidth
        property int visibleWidth
        property bool clickToShow: false
        clip: true
        height: parent.height
        Image {
            id: bladePixmap
            anchors.right: blade.right
            anchors.fill:  parent
        }
        FocusScope {
            id: content
            anchors { right: blade.right; rightMargin: bladeRightMargin }
            width: blade.width; height: blade.height
        }
        MouseArea {
            anchors.fill: parent
            onPressed: {
                root.state == "open" ? root.closed() : root.opened()
                mouse.accepted = false
            }
        }
        Behavior on x {
            NumberAnimation { duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
        }
    }
}
