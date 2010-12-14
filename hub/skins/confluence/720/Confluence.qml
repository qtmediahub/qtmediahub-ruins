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
import "../components"
//import "testing"

FocusScope {
    id: confluence

    property string generalResourcePath: backend.resourcePath
    property string themeResourcePath: backend.skinPath + "/confluence/3rdparty/skin.confluence"

    //FIXME: QML const equivalent?
    property variant confluenceEasingCurve: Easing.InQuad
    property variant confluenceAnimationDuration: 350
    property variant confluenceTransformDuration: 1000

    property variant selectedElement
    property variant videoPlayer
    property variant qtcube
    property variant browserWindow
    property variant ticker

    height: 720; width: 1280
    focus: true; clip: true

    states: [
        State {
            name: "showingRootBlade"
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
            StateChangeScript { script: blade.forceActiveFocus() }
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
            StateChangeScript { script: selectedElement.forceActiveFocus() }
        },
        State {
            name: "showingSelectedElementMaximized"
            extend: "showingSelectedElement"
            PropertyChanges {
                target: blade
                state: "hidden"
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
            selectedElement && selectedElement.maximized ? selectedElement.maximized = false : confluence.state = "showingRootBlade"
        // Just convenience remove for real use!!!!!!!
        else if(event.key == Qt.Key_Delete)
            Qt.quit();
        //FIXME: keyboard modifiers don't work?
        //else if((event.key == Qt.Key_Enter) && (keys.modifiers == Qt.AltModifier))
        else if(event.key == Qt.Key_F12)
                selectedElement && state == "showingSelectedElement" && selectedElement.maximizable && (selectedElement.maximized = true);
        else if(event.key == Qt.Key_F11) {
            confluence.selectedElement = aboutWindow
            confluence.state = "showingSelectedElement"
        }
    }

    //FIXME: function failing here simply skips rest of init, wish they had exceptions
    Component.onCompleted: {
        //Create items which may or may not be present
        var customCursorLoader = Qt.createComponent("../components/Cursor.qml")
        if(customCursorLoader.status == Component.Ready)
            customCursorLoader.createObject(confluence)
        else if(customCursorLoader.status == Component.Error)
            backend.log(customCursorLoader.errorString())

        musicEngine.pluginProperties.musicModel.setThemeResourcePath(themeResourcePath); // ## Shouldn't be here
        var musicWindowLoader = Qt.createComponent("MusicWindow.qml")
        if(musicWindowLoader.status == Component.Ready)
            musicWindowLoader.createObject(confluence)
        else if(musicWindowLoader.status == Component.Error)
            backend.log(musicWindowLoader.errorString())

        //FIXME: function failing here simply skips rest of init, wish they had exceptions
        videoEngine.pluginProperties.videoModel.setThemeResourcePath(themeResourcePath); // ## Shouldn't be here
        var videoWindowLoader = Qt.createComponent("VideoWindow.qml")
        if(videoWindowLoader.status == Component.Ready)
            videoWindowLoader.createObject(confluence)
        else if(videoWindowLoader.status == Component.Error)
            backend.log(videoWindowLoader.errorString())

        pictureEngine.pluginProperties.pictureModel.setThemeResourcePath(themeResourcePath); // ## Shouldn't be here
        var pictureWindowLoader = Qt.createComponent("PictureWindow.qml")
        if(pictureWindowLoader.status == Component.Ready)
            pictureWindowLoader.createObject(confluence)
        else if(pictureWindowLoader.status == Component.Error)
            backend.log(pictureWindowLoader.errorString())

        var videoPlayerComponent = Qt.createComponent("VideoPlayer.qml");
        if(videoPlayerComponent.status == Component.Ready) {
            videoPlayer = videoPlayerComponent.createObject(confluence)
            // FIXME: nothing to get video-path during runtime, yet
            videoPlayer.state = "hidden"
        } else if (videoPlayerComponent.status == Component.Error) {
            backend.log(videoPlayerComponent.errorString())
            videoPlayer = dummyItem
        }

        var dashboardLoader = Qt.createComponent("DashboardWindow.qml");
        if(dashboardLoader.status == Component.Ready) {
            var dashboard = dashboardLoader.createObject(confluence)
            dashboard.z = 1
        } else if (dashboardLoader.status == Component.Error) {
            backend.log(dashboardLoader.errorString())
        }

        //No webkit
        var webLoader = Qt.createComponent("WebWindow.qml");
        if(webLoader.status == Component.Ready) {
            browserWindow = webLoader.createObject(confluence)
        } else if (webLoader.status == Component.Error) {
            backend.log(webLoader.errorString())
        }

        //No XML patterns
        var weatherLoader = Qt.createComponent("WeatherWindow.qml");
        if(weatherLoader.status == Component.Ready) {
            weatherLoader.createObject(confluence)
        } else if (weatherLoader.status == Component.Error) {
            backend.log(weatherLoader.errorString())
        }

        var tickerLoader = Qt.createComponent("Ticker.qml");
        if(tickerLoader.status == Component.Ready) {
            ticker = tickerLoader.createObject(confluence)
            ticker.y = confluence.height;
            ticker.z = 1;
            ticker.anchors.right = confluence.right
        } else if (tickerLoader.status == Component.Error) {
            backend.log(tickerLoader.errorString())
            ticker = dummyItem
        }

        //no qt3d
        var qtCubeLoader = Qt.createComponent(generalResourcePath + "/misc/cube/cube.qml")
        if(qtCubeLoader.status == Component.Ready) {
            qtcube = qtCubeLoader.createObject(confluence)
            qtcube.x = confluence.width
            qtcube.anchors.top = confluence.top
            qtcube.z = 1000
        } else if(qtCubeLoader.status == Component.Error) {
            backend.log(qtCubeLoader.errorString())
            qtcube = dummyItem
        }

        confluence.state = "showingRootBlade"
    }

    function setActiveEngine(engine)
    {
        selectedElement = engine.visualElement
        var elementProperties = engine.visualElementProperties
        for(var i = 0; i + 2 <= elementProperties.length; i += 2)
            selectedElement[elementProperties[i]] = elementProperties[i+1]
        state = "showingSelectedElement"
    }

    // dummyItem useful to avoid error ouput on component loader failures
    Item {
        id: dummyItem
        visible: false
    }

    Background {
        id: background
        anchors.fill: parent;
        z: 1
        visible: !(!!videoPlayer.video && videoPlayer.video.playing)
    }

    MainBlade { 
        id: blade; 
        focus: true 
        onOpened: confluence.state = "showingRootBlade"
    }

    ExitWindow { id: exitWindow }

    Image {
        id: banner
        z: 1000
        source: themeResourcePath + "/media/Confluence_Logo.png"
    }

    AboutWindow { id: aboutWindow; clip: false }

    /*Test {
        id: componentTest
        Engine { name: qsTr("Components"); role: "components-test"; visualElement: componentTest; }
    }*/
}