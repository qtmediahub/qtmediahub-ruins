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

FocusScope {
    id: root

    property variant foo : bar()

    function bar() {
        console.log(themeResourcePath)
    }

    ListModel {
        id: menuModel

        ListElement {
            name: "Music"
        }
        ListElement {
            name: "Video"
        }
        ListElement {
            name: "Pictures"
        }
        ListElement {
            name: "System"
        }
        ListElement {
            name: "Maps"
        }
        ListElement {
            name: "Web"
        }
        ListElement {
            name: "Media Player"
        }
    }

    Panel {
        id: panel
        width: 700
        height: 550
        anchors.centerIn: parent
        visible: true
        opacity: visible ? 1 : 0

        ListView {
            id: listView
            anchors.fill: parent;
            clip: true
            focus: true
            model: menuModel
            spacing:  30

            delegate : Item {
                id: delegateItem

                property int angle: ListView.isCurrentItem ? 0 : 360

                width: listView.width
                height: sourceText.height + 8
                scale: ListView.isCurrentItem ? 1 : 0.8

                transformOrigin: Item.Right

                transform: Rotation { origin.x: childrenRect.width/2.0; origin.y: childrenRect.height/2.0; axis { x: 1; y: 0; z: 0 } angle: delegateItem.angle }

                Behavior on scale { NumberAnimation{ } }
                Behavior on angle { NumberAnimation{ } }

                Image {
                    id: backgroundImage
                    anchors.fill: parent;
                    source: "file://" + themeResourcePath + "/media/" + (ListView.isCurrentItem ? "MenuItemFO.png" : "MenuItemNF.png");
                }

                Text {
                    id: sourceText
                    anchors { right: parent.right; rightMargin: 50 }
                    anchors.verticalCenter: parent.verticalCenter
                    z: 1
                    text: name
                    font.pointSize: 30
                    color: "white"
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent;
                    hoverEnabled: true
                    onEntered:
                        listView.currentIndex = index
                }
            }
        }
    }

    Behavior on opacity {
        NumberAnimation { easing.type: confluenceEasingCurve; duration: confluenceAnimationDuration }
    }
}
