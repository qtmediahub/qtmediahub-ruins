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

#include <QtDeclarative>

#ifndef QMXWINDOW_H
#define QMXWINDOW_H

//QDI so we're in the scene and associated with a window
class QMxWindow : public QDeclarativeItem
{

    Q_OBJECT
    public:
        QMxWindow(QDeclarativeItem * parent=0);

    public slots:
        void resetMove();
        void resetResize();
        void dragPointMove(int x, int y);
        void dragPointResize(int x, int y);

    private:
        bool moveValid, resizeValid;
        QPoint lastMovePoint;
        QPoint lastResizePoint;
};

QML_DECLARE_TYPE(QMxWindow);

#endif // QMXWINDOW_H
