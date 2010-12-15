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
import QtWebKit 1.0
import confluence.components 1.0
import Qt.labs.Mx 1.0 as MxComponents


Window {
    id: root

    maximizable: true

    property alias url: webView.url
    property string defaultUrl: "http://www.google.com"

    function onVisibleTransitionComplete() {
        webView.forceActiveFocus()
    }

    function loadPage(url) {
        webView.url = url
        webViewport.contentY = 0

        confluence.selectedElement = root
        confluence.state = "showingSelectedElement"
    }

    Keys.onPressed: {
        if ((event.key == Qt.Key_Down) && (event.modifiers & Qt.MetaModifier)) {
            webviewPopup.forceActiveFocus()
        } else if(event.key == Qt.Key_Escape) {
            if(webviewPopup.activeFocus) {
                webView.forceActiveFocus()
                event.accepted = true
            }
        }
    }

    Panel {
        id: panel
        anchors.centerIn: parent;
        decorateFrame: !root.maximized
        Flickable {
            id: webViewport
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection:  Flickable.VerticalFlick
            width: root.maximized ? confluence.width : webView.width; 
            height: root.maximized ? confluence.height : root.height - 60
            contentWidth: webView.width; 
            contentHeight: webView.height
            WebView {
                id: webView
                //anchors.centerIn: parent
                //FIXME: is this expensive at all?
                //width: root.width
                url: defaultUrl
                opacity: progress == 1 ? 1 : 0.5

                Behavior on opacity {
                    NumberAnimation{}
                }

            }

            Behavior on width {
                NumberAnimation { }
            }
        }

        BusyIndicator {
            anchors.centerIn: webViewport
            on: webView.progress != 1
        }

    }

    FocusScope {
        id: webviewPopup
        z:10
        anchors { horizontalCenter: parent.horizontalCenter }
        y: -height
        width: childrenRect.width; height: childrenRect.height

        states: State {
            name: "visible"
            when: urlBar.activeFocus || googleBar.activeFocus                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               //urlBar.activeFocus || googleBar.activeFocus
            PropertyChanges {
                target: webviewPopup
                y: 0
            }
            PropertyChanges {
                target: urlEntry
                text: webView.url ? webView.url : urlEntry.defaultText
            }
        }

        Behavior on y {
            NumberAnimation {}
        }

        ConfluenceFlipable {
            id: flippable
            width: urlBar.width; height: urlBar.height


            //flipped: googleBar.activeFocus

            front:
                Panel {
                id: urlBar

                ConfluenceText {
                    id: inputLabel
                    text: "url:"
                }
                MxComponents.Entry {
                    id: urlEntry
                    property string defaultText: "http://"
                    text: defaultText
                    width: 440
                    anchors { left: inputLabel.right; verticalCenter: inputLabel.verticalCenter }
                    hint: "url"
                    leftIconSource: generalResourcePath + "/mx-images/edit-find.png"
                    onLeftIconClicked: {
                        flippable.flipped = !flippable.flipped
                        googleBar.forceActiveFocus()
                    }
                    rightIconSource: generalResourcePath + "/mx-images/edit-clear.png"
                    onRightIconClicked: text=defaultText
                    onEnterPressed: {
                        webView.url = text
                        webView.forceActiveFocus()
                    }
                    Connections {
                        target: webView
                        onLoadFinished:
                            urlEntry.text = webView.url
                    }
                }
            }
            back: Panel {
                id: googleBar
                anchors.fill: parent
                ConfluenceText {
                    id: googleLabel
                    text: "google:"
                }
                MxComponents.Entry {
                    anchors { left: googleLabel.right; verticalCenter: googleLabel.verticalCenter; right: parent.right }
                    hint: "Search..."
                    leftIconSource: generalResourcePath + "/mx-images/scroll-button-right.png"
                    onLeftIconClicked: {
                        flippable.flipped = !flippable.flipped
                        urlBar.forceActiveFocus()
                    }
                    rightIconSource: generalResourcePath + "/mx-images/edit-clear.png"
                    onRightIconClicked: text=""
                    onEnterPressed: {
                        webView.url = "http://www.google.com/search?q=" + text
                        webView.forceActiveFocus()
                    }
                }
            }
        }
    }

    Engine { name: qsTr("Web"); role: "web"; visualElement: root; visualElementProperties: ["url", defaultUrl] }
    Engine { name: qsTr("Store"); role: "ovi-store"; visualElement: root; visualElementProperties: ["url", "http://store.ovi.com/"] }
    Engine { name: qsTr("Maps"); role: "maps"; visualElement: root; visualElementProperties: ["url", generalResourcePath + "/Google\ Maps/Nokia.html"] }
}
