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
    id: rootMenu
    height: parent.height; width: parent.width

    property variant menuSoundEffect
    property string name: "rootmenu"
    property alias currentItem: rootMenuList.currentItem
    property alias currentIndex: rootMenuList.currentIndex
    property alias buttonGridX : buttonGrid.x

    signal openSubMenu

    Component.onCompleted: {
        var clickComponent = Qt.createComponent("../components/QMHAudio.qml");
        if(clickComponent.status == Component.Ready) {
            menuSoundEffect = clickComponent.createObject(parent)
            menuSoundEffect.source = themeResourcePath + "/sounds/click.wav"
        } else if (clickComponent.status == Component.Error) {
            backend.log(clickComponent.errorString())
        }

        rootMenuList.currentIndex = 0;
    }

    Keys.onLeftPressed:
        buttonGrid.focusUpperItem()

    ListView {
        id: rootMenuList

        signal itemSelected

        //Oversized fonts being downscaled
        spacing: 30
        focus: true

        anchors.fill: parent
        preferredHighlightBegin: banner.height; preferredHighlightEnd: height - buttonGrid.height
        highlightRangeMode: ListView.StrictlyEnforceRange

        highlight: Image {
            source:  themeResourcePath + "/media/black-back2.png"
            opacity:  0.5
        }

        model: backend.engines //menuList
        delegate:
            RootMenuListItem { }

        onCurrentIndexChanged: {
            background.role = currentItem.role
            if(menuSoundEffect != undefined) {
                menuSoundEffect.play()
            }
        }

        Keys.onEnterPressed:
            currentItem.trigger()
        Keys.onReturnPressed:
            currentItem.trigger()
        Keys.onRightPressed:
            rootMenu.openSubMenu()
    }

    Image {
        id: banner
        x: 20
        z: rootMenuList.z + 1
        source: themeResourcePath + "/media/Confluence_Logo.png"
    }

    Component {
        id: exitDialogComponent
        ExitDialog { }
    }

    ButtonList {
        id: buttonGrid
        y: parent.height - height; // # FIXME: Should not access mainBlade
        spacing: 2
        width: parent.width

        onUpperBoundExceeded: {
            rootMenuList.focus = true
        }

        PixmapButton {
            basePixmap: "home-playmedia"
            focusedPixmap: "home-playmedia-FO"
            onClicked: {
                confluence.show(videoPlayer)
            }
        }
        PixmapButton { basePixmap: "home-favourites"; focusedPixmap: "home-favourites-FO" }
        PixmapButton {
            basePixmap: "home-power";
            focusedPixmap: "home-power-FO";
            onClicked:
                confluence.showModal(exitDialogComponent)
        }
    }
}
