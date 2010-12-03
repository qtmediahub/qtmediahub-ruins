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

ListView {
    id: listView
    property alias treeModel : visualDataModel.model
    property alias rootIndex : visualDataModel.rootIndex
    signal clicked()
    signal rootIndexChanged() // this should be automatic, but doesn't trigger :/

    function currentModelIndex() {
        //console.log(currentItem.itemdata.filePath);
        return visualDataModel.modelIndex(currentIndex);
    }

    model : visualDataModel

    VisualDataModel {
        id: visualDataModel
        delegate : Item {
            property variant itemdata : model
            width: listView.width
            height: sourceText.height + 8
            Image {
                id: backgroundImage
                anchors.fill: parent; 
                source: themeResourcePath + "/media/" + (ListView.isCurrentItem ? "MenuItemFO.png" : "MenuItemNF.png");
            }
            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                z: 1 // ensure it is above the background
                text: model.display
                font.pointSize: 16
                color: "white"
            }

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                onEntered:
                    listView.currentIndex = index
                onClicked: {
                    if (model.hasModelChildren) {
                        visualDataModel.rootIndex = visualDataModel.modelIndex(index)
                        listView.rootIndexChanged();
                    } else if (model.display == qsTr("..")) {
                        visualDataModel.rootIndex = visualDataModel.parentModelIndex();
                        listView.rootIndexChanged();
                    } else {
                        listView.currentIndex = index;
                        listView.clicked()
                    }
                }
            }
        }
    }
}

