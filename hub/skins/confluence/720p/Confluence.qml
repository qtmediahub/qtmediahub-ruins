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
import "components"

FocusScope {
    id: confluence

    property string generalResourcePath: backend.resourcePath
    property string themeResourcePath: backend.skinPath + "/confluence/3rdparty/skin.confluence"

    //FIXME: QML const equivalent?
    property variant confluenceEasingCurve: Easing.InOutQuad
    property variant confluenceAnimationDuration: 350
    property variant confluenceTransformDuration: 1000

    property variant selectedElement
    property variant videoPlayer
    property variant qtcube

    height: 720; width: 1280
    focus: true; clip: true

    states: [
        State {
            name: "showingRootMenu"
            PropertyChanges {
                target: blade
                state: "open"
                visibleContent: blade.rootMenu
            }
            PropertyChanges {
                target: qtcube
                x: confluence.width - qtcube.width
            }
            PropertyChanges {
                target: ticker
                y: confluence.height - ticker.height
            }
            PropertyChanges {
                target: videoPlayer
                state: "background"
            }
        },
        State {
            name: "showingSelectedElement"
            PropertyChanges {
                target: blade
                state: "closed"
                visibleContent: selectedElement.bladeContent
            }
            PropertyChanges {
                target: selectedElement
                state: "visible"
            }
            PropertyChanges {
                target: videoPlayer
                state: "background"
            }
        },
        State {
            name: "showingSelectedElementMaximized"
            extend: "showingSelectedElement"
            PropertyChanges {
                target: blade
                x: -blade.bladePeek
            }
            PropertyChanges {
                target: selectedElement
                state: "maximized"
            }
            PropertyChanges {
                target: videoPlayer
                state: "hidden"
            }
        },
        State {
            //FIXME: This is hopefully temporary and can be merged into the
            //above state
            name: "showingVideoPlayer"
            PropertyChanges {
                target: blade
                state: "closed"
                visibleContent: selectedElement.bladeContent
                x: -blade.bladePeek
            }
            PropertyChanges {
                target: videoPlayer
                state: "maximized"
            }
            StateChangeScript { script: videoPlayer.forceActiveFocus() }
        }

    ]

    transitions: Transition {
        reversible: true
        NumberAnimation { properties: "x,y"; easing.type: confluenceEasingCurve; duration: confluenceAnimationDuration }
    }

    Keys.onPressed: {
        if(event.key == Qt.Key_Escape)
            selectedElement && selectedElement.maximized ? selectedElement.maximized = false : confluence.state = "showingRootMenu"
        // Just convenience remove for real use!!!!!!!
        else if(event.key == Qt.Key_Delete)
            Qt.quit();
        //FIXME: keyboard modifiers don't work?
        //else if((event.key == Qt.Key_Enter) && (keys.modifiers == Qt.AltModifier))
        else if(event.key == Qt.Key_F12)
                selectedElement && selectedElement.maximizable && (selectedElement.maximized = true);
    }

    Component.onCompleted: {
        //Create items which may or may not be present

        var customCursorLoader = Qt.createComponent("components/Cursor.qml")
        if(customCursorLoader.status == Component.Ready)
            customCursorLoader.createObject(confluence)
        else if(customCursorLoader.status == Component.Error)
            console.log(customCursorLoader.errorString())

        // ## This should probably not be here
        musicEngine.pluginProperties.musicModel.setThemeResourcePath(confluence.themeResourcePath);
        musicEngine.pluginProperties.musicModel.start();
        var musicDialogLoader = Qt.createComponent("MusicDialog.qml")
        if(musicDialogLoader.status == Component.Ready)
            musicDialogLoader.createObject(confluence)
        else if(musicDialogLoader.status == Component.Error)
            console.log(musicDialogLoader.errorString())

        var videoPlayerComponent = Qt.createComponent("VideoPlayer.qml");
        if(videoPlayerComponent.status == Component.Ready) {
            videoPlayer = videoPlayerComponent.createObject(confluence)
            // FIXME: nothing to get video-path during runtime, yet
            videoPlayer.video.source = "/home/jzellner/video/big_buck_bunny_1080p_surround.avi";
            videoPlayer.state = "hidden"
        } else if (videoPlayerComponent.status == Component.Error) {
            console.log(videoPlayerComponent.errorString())
        }

        var dashboardLoader = Qt.createComponent("ConfluenceDashboard.qml");
        if(dashboardLoader.status == Component.Ready) {
            var dashboard = dashboardLoader.createObject(confluence)
            dashboard.z = 1
        } else if (dashboardLoader.status == Component.Error) {
            console.log(dashboardLoader.errorString())
        }
        var qtCubeLoader = Qt.createComponent(generalResourcePath + "/misc/cube/cube.qml")
        if(qtCubeLoader.status == Component.Ready) {
            qtcube = qtCubeLoader.createObject(confluence)
            qtcube.x = confluence.width
            qtcube.anchors.top = confluence.top
            qtcube.z = 1000
        } else if(qtCubeLoader.status == Component.Error)
            console.log(qtCubeLoader.errorString())

        confluence.state = "showingRootMenu"
    }

    function setActiveEngine(engine)
    {
        selectedElement = engine.visualElement
        var elementProperties = engine.visualElementProperties
        for(var i = 0; i + 2 <= elementProperties.length; i += 2)
            selectedElement[elementProperties[i]] = elementProperties[i+1]
        state = "showingSelectedElement"
    }

    Background{
        id: background
        anchors.fill: parent;
        z: 1
        visible: !videoPlayer.video.playing
    }

    MainBlade { 
        id: blade; 
        focus: true 
        onOpened: confluence.state = "showingRootMenu"
    }

    ExitDialog { id: exitDialog }

    Ticker { id: ticker; y: confluence.height; z: 1; anchors { right: parent.right } }

    WebDialog { id: webDialog }

    Image {
        id: banner
        z: 1000
        source: themeResourcePath + "/media/Confluence_Logo.png"
    }

    SystemDialog {
        id: systemDialog
        Component.onCompleted:
            systemEngine.visualElement = systemDialog
    }

    WeatherDialog { id: weatherDialog; }

    AboutDialog {}

    //    BusyIndicator {
    //        on: true
    //        anchors.right: parent.right
    //        anchors.top: parent.top
    //    }
}
