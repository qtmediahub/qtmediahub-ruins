/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.0
import "PhotoViewerCore"

Rectangle {
    id: mainWindow

    property real downloadProgress: 0
    property bool imageLoading: false
    property bool editMode: false

    width: 800; height: 480; color: "#d5d6d8"

    ListModel {
        id: photosModel
        ListElement { tag: "Flowers" }
        ListElement { tag: "Wildlife" }
        ListElement { tag: "Prague" }
    }

    VisualDataModel { id: albumVisualModel; model: photosModel; delegate: AlbumDelegate {} }

    GridView {
        id: albumView; width: parent.width; height: parent.height; cellWidth: 210; cellHeight: 220
        model: albumVisualModel.parts.album; visible: albumsShade.opacity != 1.0
    }

    Column {
        spacing: 20; anchors { bottom: parent.bottom; right: parent.right; rightMargin: 20; bottomMargin: 20 }
        Button {
            id: newButton; label: qsTr("Add"); rotation: 3
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                mainWindow.editMode = false
                photosModel.append( { tag: "" } )
                albumView.positionViewAtIndex(albumView.count - 1, GridView.Contain)
            }
        }
        Button {
            id: deleteButton; label: qsTr("Edit"); rotation: -2;
            onClicked: mainWindow.editMode = !mainWindow.editMode
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: albumsShade; color: mainWindow.color
        width: parent.width; height: parent.height; opacity: 0.0
    }

    ListView { anchors.fill: parent; model: albumVisualModel.parts.browser; interactive: false }

    Button { id: backButton; label: qsTr("Back"); rotation: 3; x: parent.width - backButton.width - 6; y: -backButton.height - 8 }

    Rectangle { id: photosShade; color: 'black'; width: parent.width; height: parent.height; opacity: 0; visible: opacity != 0.0 }

    ListView { anchors.fill: parent; model: albumVisualModel.parts.fullscreen; interactive: false }

    Item { id: foreground; anchors.fill: parent }

    ProgressBar {
        progress: mainWindow.downloadProgress; width: parent.width; height: 4
        anchors.bottom: parent.bottom; opacity: mainWindow.imageLoading; visible: opacity != 0.0
    }
}
