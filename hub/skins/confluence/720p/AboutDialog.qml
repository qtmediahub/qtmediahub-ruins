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

Dialog {
    id: root

    property variant startupAnimationComponent

    onVisibleChanged: {
        if(visible == true) {
            startupAnimationComponent = Qt.createComponent(generalResourcePath + "/qml-startup/startup.qml")
            if(startupAnimationComponent.status == Component.Ready)
                back = startupAnimationComponent.createObject(root)
        } else {
            startupAnimationComponent.destroy()
            back.destroy()
            back = startupAnimationComponent.createObject(root)
        }
    }

    Flow {
        anchors.centerIn: parent
        //width: childrenRect.width; height: childrenRect.height
        flow:  Flow.TopToBottom
        Item {
            width: childrenRect.width; height: childrenRect.height
            ConfluenceText { id: confTxt; text: qsTr("All resources and style from ") }
            Image {
                anchors { left: confTxt.right; verticalCenter: confTxt.verticalCenter }
                source: themeResourcePath + "/media/Confluence_Logo.png"
            }
        }
        Item {
            width: childrenRect.width; height: childrenRect.height
            ConfluenceText { id: xbmcTxt; text: qsTr("Inspired by ") }
            Image {
                anchors { left: xbmcTxt.right; verticalCenter: xbmcTxt.verticalCenter }
                source: themeResourcePath + "/media/XBMC_Logo.png"
            }
        }
        ConfluenceText { text: "http://xbmc.org/"}
        ConfluenceText { text: "QtMediaCenter is hosted at http://gitorious.org/qtmediahub"}
    }

    PropertyAnimation on angle {
        loops: Animation.Infinite
        duration: 10000
        from: 0
        to: 360
    }
}
