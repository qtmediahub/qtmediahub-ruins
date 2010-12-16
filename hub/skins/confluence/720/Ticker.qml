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

BorderImage {
    id: root
    border.left: 100
    anchors.topMargin: 0
    anchors.top:  parent.bottom

    source: themeResourcePath + "/media/Rss_Back.png"

    width: parent.width/1.5;

    property string currentFeed: "rss.news.yahoo.com/rss/topstories"
    property bool active: confluence.state == "showingRootBlade"

    signal linkClicked (string link);

    onLinkClicked: {
        browserWindow ? browserWindow.loadPage(link) : backend.openUrlExternally(link)
    }

    XmlListModel {
        id: feedModel
        source: "http://" + root.currentFeed
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "description"; query: "description/string()" }
    }

    ListView {
        id: list
        clip: true
        anchors.right : parent.right
        anchors.verticalCenter: parent.verticalCenter
        orientation: ListView.Horizontal
        width: parent.width - 40; height: parent.height - 5
        interactive: false

        model: feedModel
        delegate: Item {
            id: tickerItem
            width: childrenRect.width; height: parent.height
            ConfluenceText {
                id: tickerTitle;
                font.pointSize: 15
                text: title.replace("\n", "")
                color: delegateMouseArea.containsMouse ? "steelblue" : "white"
            }

            ConfluenceText { font.pointSize: 15; anchors.left: tickerTitle.right; text: " - "; color: "steelblue" }

            MouseArea {
                id: delegateMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: linkClicked(link)
            }
        }

        Timer {
            interval: 50;
            running: root.active && !list.flicking
            repeat: true
            onTriggered: list.contentX = list.contentX + 2
        }
    }

    BorderImage {
        source: themeResourcePath + "/media/Rss_Back_Overlay.png"
        border.left: 100
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root.anchors
                topMargin: -root.height
            }
        }
    ]

    transitions: Transition {
        reversible: true
        NumberAnimation { target: anchors; properties: "topMargin"; easing.type: confluenceEasingCurve; duration: confluenceAnimationDuration }
    }
}
