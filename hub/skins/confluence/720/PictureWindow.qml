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

Window {
    id: root

    Component {
        id: pictureInformationSheet
        PictureInformationSheet {
        }
    }

    Panel {
        id: sourcesWindow
        x: 60
        y: 80
        width: 700
        height: 650

       TreeView {
            id: sourcesListView
            anchors.fill: parent;
            treeModel: pictureEngine.pluginProperties.pictureModel
            clip: true
            focus: true;
            onClicked: {
                if (currentItem.itemdata.type == "AddNewSource")
                    confluence.showModalDialog(addMediaSourceDialog)
            }
            Keys.onPressed: {
                var itemType = sourcesListView.currentItem.itemdata.type
                if (itemType == "SearchPath") {
                    if (event.key == Qt.Key_Delete) {
                        treeModel.removeSearchPath(currentIndex)
                        event.accepted = true
                    }
                } else if (itemType == "File") {
                    if (event.key == Qt.Key_I) {
                        var sheet =  confluence.showModalDialog(pictureInformationSheet)
                        sheet.currentItem = sourcesListView.currentItem // this is not a binding for lazy loading
                        event.accepted = true
                    }
                }
            }
        }
    }

    Item {
        id: sourceArtWindow
        anchors.left: sourcesWindow.right;
        anchors.leftMargin: 65;
        anchors.bottom: sourcesWindow.bottom;

        width: sourcesArt.width
        height: sourcesArt.height

        ImageCrossFader {
            id: sourcesArt
            anchors.fill: parent;

            width: sourcesListView.currentItem.itemdata.previewWidth
            height: sourcesListView.currentItem.itemdata.previewHeight
            source: sourcesListView.currentItem.itemdata.previewUrl
        }
    }

    Component.onCompleted: {
        pictureEngine.visualElement = root;
        pictureEngine.pluginProperties.pictureModel.setThemeResourcePath(themeResourcePath);
    }

    Component {
        id: addMediaSourceDialog
        AddMediaSource {
            title: qsTr("Add Picture source")
            engineModel: pictureEngine.pluginProperties.pictureModel
            opacity: 0

            onClosed: sourcesListView.forceActiveFocus()
        }
    }
}

