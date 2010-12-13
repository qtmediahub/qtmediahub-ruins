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

Window {
    id: root

    Panel {
        id: sourcesWindow
        x: 60
        y: 80
        width: 700
        height: 550
        visible: true
        opacity: visible ? 1 : 0

       TreeView {
            id: sourcesListView
            anchors.fill: parent;
            treeModel: videoEngine.pluginProperties.videoModel
            clip: true
            focus: true

            onClicked: {
                if (currentItem.itemdata.type == "AddNewSource")
                    addMediaSourceDialog.open();
                else
                    videoPlayer.play(currentItem.itemdata.filePath)
            }
            Keys.onPressed: {
                if (event.key == Qt.Key_Delete) {
                    treeModel.removeSearchPath(currentIndex);
                    event.accepted = true;
                }
            }
        }

       Behavior on opacity {
           NumberAnimation { easing.type: confluenceEasingCurve; duration: confluenceAnimationDuration }
       }
    }

    FocusScope {
        id: sourcesposterWindow
        anchors.fill: parent
        visible: false
        opacity: visible ? 1 : 0

        BorderImage {
            id: sourcesPosterViewBackground
            source: themeResourcePath + "/media/ContentPanel2.png"
            anchors.fill: parent
            border.left: 5; border.top: 5
            border.right: 5; border.bottom: 5
        }

        PosterView {
            id: sourcesPosterView
            width: parent.width
            height: 300
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            treeModel: videoEngine.pluginProperties.videoModel
            clip: true
            focus: true;
            onClicked: {
                videoPlayer.play(filePath)
            }
        }

        ConfluenceText {
            anchors.top:  sourcesPosterView.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            text: sourcesPosterView.currentSelectedName
        }

        ConfluenceText {
            anchors.top:  sourcesPosterView.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            font.bold: false
            color: "steelblue"
            text: sourcesPosterView.currentSelectedSize < 0 ? "" : (sourcesPosterView.currentSelectedSize/1000000).toFixed(2) + " MB"
        }

        Behavior on opacity {
            NumberAnimation { easing.type: confluenceEasingCurve; duration: confluenceAnimationDuration }
        }
    }

    Item {
        id: sourceArtWindow
        anchors.left: sourcesWindow.right;
        anchors.leftMargin: 65;
        anchors.bottom: sourcesWindow.bottom;
        visible: sourcesWindow.visible
        opacity: visible ? 1 : 0

        width: sourcesArt.width
        height: sourcesArt.height

        ImageCrossFader {
            id: sourcesArt
            anchors.fill: parent;

            width: sourcesListView.currentItem.itemdata.previewWidth
            height: sourcesListView.currentItem.itemdata.previewHeight
            source: sourcesListView.currentItem.itemdata.previewUrl
        }

        Behavior on opacity {
            NumberAnimation { easing.type: confluenceEasingCurve; duration: confluenceAnimationDuration }
        }
    }

    Button {
        id: switchViews
        text: sourcesWindow.visible ? "Poster View" : "List View"
        width:  200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        onClicked: {
            sourcesWindow.visible = !sourcesWindow.visible
            sourcesposterWindow.visible = !sourcesposterWindow.visible
            // workaround to update things within PathView
            sourcesPosterView.incrementCurrentIndex();
        }
    }

    Component.onCompleted: {
        videoEngine.visualElement = root;
    }

    AddMediaSource {
        id: addMediaSourceDialog
        title: qsTr("Add Video source")
        engineModel: videoEngine.pluginProperties.videoModel
        opacity: 0
    }
}

