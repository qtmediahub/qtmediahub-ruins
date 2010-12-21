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
import "../components/"

Header {
    id: root
    width: row.x + row.width + 35

    property string city: "Munich"

    XmlListModel {
        id: currentConditions
        source: "http://www.google.com/ig/api?weather=" + city
        query: "/xml_api_reply/weather/current_conditions"

        //current condition
        XmlRole { name: "temp_c"; query: "temp_c/@data/string()" }
        XmlRole { name: "icon"; query: "icon/@data/string()" }
    }

    function mapIcon(name) {
        var i = name.lastIndexOf("/")+1;
        var sn = themeResourcePath+"/media/weathericons/"+name.substr(i, name.length-i-4)+".png";
        return sn;
    }

    Row {
        id: row
        z: 1
        spacing: 5
        x: 20
        Image {
            id: weatherIcon
            width: weatherDegree.height
            height: width
            smooth: true
            asynchronous: true
            source: currentConditions.count > 0 ? mapIcon(currentConditions.get(0).icon) : ""
        }
        Text {
            id: weatherDegree
            color: "white"
            font.pointSize: 14
            text: (currentConditions.count > 0 ? currentConditions.get(0).temp_c : "0") + "°C"
        }
    }
}

