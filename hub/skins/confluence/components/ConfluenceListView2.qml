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

Repeater {
    id: repeater
    property int currentIndex: 0

    signal activated(variant item)

    Keys.onEnterPressed:
        repeater.activated(repeater.currentItem)

    delegate: Item {
        id: delegate
        property variant modeldata: model
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
                when: repeater.currentIndex == index
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
                repeater.currentIndex = index
                repeater.forceActiveFocus()
            }

            onClicked: {
                if (model.options) {
                    var options = model.options.split(",")
                    repeater.model.setProperty(index, "currentOption", (currentOption+1)%options.length)
                }
                repeater.activated(delegate)
            }
        }
    }
}

