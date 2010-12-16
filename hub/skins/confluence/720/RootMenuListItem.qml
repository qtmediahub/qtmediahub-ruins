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
import confluence.components 1.0

Item {
    id: menuItem
    width: parent.width; height: entry.height

    property string role: model.modelData.role
    property bool hasSubBlade: model.modelData.browseable
    property alias textColor: entry.color
    property alias text: entry.text
    property int angle: 0

    anchors.right: parent.right
    transformOrigin: Item.Right

    transform: Rotation { origin.x: childrenRect.width/2.0; origin.y: childrenRect.height/2.0; axis { x: 1; y: 0; z: 0 } angle: menuItem.angle }

    opacity: 0.5
    scale: 0.5

    states: [
        State {
            name: 'selected'
            when: activeFocus && ListView.isCurrentItem && mainBlade.subMenu.state == "closed"
            PropertyChanges { target: menuItem; scale: 1; opacity: 1; angle: 360 }
            StateChangeScript { script: rootMenuList.itemSelected() }
            PropertyChanges { target: subIndicator; opacity: 1 }
        },
        State {
            name: 'triggered'
            when: ListView.isCurrentItem && mainBlade.subMenu.state == "open"
            PropertyChanges { target: menuItem; opacity: 0.5 }
        },
        State {
            name: 'non-triggered'
            when: !ListView.isCurrentItem && mainBlade.subMenu.state == "open"
            PropertyChanges { target: menuItem; opacity: 0 }
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            PropertyAction { target: entry; property: "smooth"; value: "false" }
            ParallelAnimation {
                NumberAnimation { property: "scale"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
                NumberAnimation { property: "opacity"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
                NumberAnimation { property: "angle"; duration: confluenceAnimationDuration; easing.type: confluenceEasingCurve }
            }
            PropertyAction { target: entry; property: "smooth"; value: "true" }
        }
    }

    function trigger() {
        confluence.setActiveEngine(model.modelData)
    }

    ConfluenceText {
        id: entry
        anchors { right: parent.right; rightMargin: 20 }
        font.pixelSize: 60
        text: model.modelData.name
        horizontalAlignment: Text.AlignRight
        transformOrigin: Item.Right
        width: parent.width
        font.weight: Font.Bold
        MouseArea {
            id: mr
            anchors.fill: entry
            hoverEnabled: true

            onEntered: {
                rootMenuList.currentIndex = index
                rootMenuList.forceActiveFocus()
            }
            onClicked: {
                trigger()
            }
        }
    }

    Image {
        id: subIndicator
        anchors { right: entry.right; top: entry.bottom; topMargin: -20; rightMargin: -20 }
        source: themeResourcePath + "/media/HomeHasSub.png"
        visible: hasSubBlade
        opacity: 0
        smooth: true
        scale: 0.6
    }
}
