/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import Qt 4.7
import com.meego 1.0

Item {
    width: 300
    height: 300

    Rectangle {
        id: rectangle
        anchors.left: buttons.left
        anchors.right: buttons.right
        anchors.top: parent.top
        anchors.bottom: buttons.top

        anchors.topMargin: 10
        anchors.bottomMargin: 10
        color: "green"
    }

    ButtonRow {
        id: buttons
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.bottomMargin: 10
        anchors.leftMargin: anchors.bottomMargin
        anchors.rightMargin: anchors.bottomMargin

        groupType: "None"

        function darker(reply) {
            if (reply == "Yes")
                rectangle.color = Qt.darker(rectangle.color)
        }

        function lighter(reply) {
            if (reply == "Yes")
                rectangle.color = Qt.lighter(rectangle.color)
        }

        Button {
            text: "Darker"
            onClicked: window.showQuery("Change color",
                                        "Make the rectangle color darker?",
                                        buttons.darker);

            width: parent.width / parent.children.length
        }

        Button {
            text: "Lighter"
            onClicked: window.showQuery("Change color",
                                        "Make the rectangle color lighter?",
                                        buttons.lighter);
            width: parent.width / parent.children.length
        }
    }
}
