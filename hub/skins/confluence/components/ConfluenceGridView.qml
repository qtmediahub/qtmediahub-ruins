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

GridView {
    id: listView
    property alias treeModel : visualDataModel.model
    property alias rootIndex : visualDataModel.rootIndex
    signal clicked()
    signal rootIndexChanged() // this should be automatic, but doesn't trigger :/

    function currentModelIndex() {
        //console.log(currentItem.itemdata.filePath);
        return visualDataModel.modelIndex(currentIndex);
    }

    BorderImage {
        id: scrollbar
        height: listView.height
        anchors.right: listView.right

        source: themeResourcePath + "/media/ScrollBarV.png"
        border { top: 14; right: 0; bottom: 14; left: 0; }
        width: 24

        BorderImage {
            id: slider
            width: scrollbar.width
            // got to love the math here
            y: Math.max(0, listView.visibleArea.yPosition * scrollbar.height)
            height: listView.visibleArea.heightRatio * scrollbar.height + Math.min(0, listView.visibleArea.yPosition * scrollbar.height)
                    + Math.min((1-listView.visibleArea.heightRatio-listView.visibleArea.yPosition) * scrollbar.height, 0)
            source: themeResourcePath + "/media/ScrollBarV_bar.png"
            border { top: 14; right: 0; bottom: 14; left: 0; }
        }
    }

    model : visualDataModel
    keyNavigationWraps: true
    clip: true

    cellWidth: 154; cellHeight: 154

    VisualDataModel {
        id: visualDataModel
        delegate : Item {
            id: delegateItem
            property variant itemdata : model
            width: sourceImg.width
            height: sourceImg.height

            Image {
                id: sourceImg
                width: 142
                height: 142
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                z: 1 // ensure it is above the background
                source: model.previewUrl
            }

            Text {
                anchors.bottom: sourceImg.bottom
                z: 2 // ensure it is above the background
                width:  sourceImg.width
                text: model.display
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 10
                font.weight: Font.Light
                color: "white"
                visible: model.type != "File"
            }

            function trigger() {
                if (model.hasModelChildren) {
                    visualDataModel.rootIndex = visualDataModel.modelIndex(index)
                    listView.rootIndexChanged();
                } else if (model.type == "DotDot") { // FIXME: Make this MediaModel.DotDot when we put the model code in a library
                    visualDataModel.rootIndex = visualDataModel.parentModelIndex();
                    listView.rootIndexChanged();
                } else {
                    listView.currentIndex = index;
                    listView.clicked()
                }
            }

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                onEntered: {
                    listView.currentIndex = index
                    currentItem.forceActiveFocus()
                }
                onClicked: {
                    delegateItem.trigger()
                }
            }

            Keys.onReturnPressed: delegateItem.trigger()
        }
    }
}

