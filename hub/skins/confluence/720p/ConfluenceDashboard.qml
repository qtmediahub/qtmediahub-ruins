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
import Dashboard 1.0

import "components"

//FIXME: polish this puppy

Dialog {
    id: dashboardDialog
    defaultWidth: maximizedWidth; defaultHeight: maximizedHeight
    Dashboard {
        id: db
        clip: true
        anchors.fill: parent

        state: "invisible"

        widgetPath: generalResourcePath + "/widgets"

        /* FIXME: constrained widgets
    Grid {
        id: grid
        z: 1
        scale: scaleFactor()
        columns: Math.sqrt(children.length)
        spacing: 50
        anchors.margins: spacing
        anchors.centerIn: parent

        function scaleFactor() {
            var widthRatio = (db.width - (columns+1)*spacing)/childrenRect.width
            var heightRatio = (db.height - (rows+1)*spacing)/childrenRect.height
            var scale = widthRatio < heightRatio ? widthRatio : heightRatio
            return scale
        }
    }*/

        Component.onCompleted: {
            var list  = db.discoverWidgets()
            for(var i = 0; i < list.length; ++i) {
                var dbComponent = Qt.createComponent("components/DashboardItem.qml")
                if (dbComponent.status == Component.Error)
                    console.log(dbComponent.errorString())
                var item = dbComponent.createObject(db)

                var widget = Qt.createComponent(list[i])
                if(widget.status == Component.Ready)
                    widget.createObject(item.container)
                else if(widget.status == Component.Error)
                    console.log(widget.errorString())
            }
            backend.engine("dashboard").visualElement = dashboardDialog
        }
    }
}
