/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the test suite of the Qt Toolkit.
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
** $QT_END_LICENSE$
**
****************************************************************************/
#include <QtTest/QtTest>
#include <QtTest/QSignalSpy>
#include <QtDeclarative/qdeclarativeengine.h>
#include <QtDeclarative/qdeclarativecontext.h>
#include <QtDeclarative/qdeclarativecomponent.h>
#include <QDeclarativeView>
#include <qdeclarativewindow.h>

class tst_quickcomponentsscrolldecorator : public QObject

{
    Q_OBJECT
public:
    tst_quickcomponentsscrolldecorator();

private slots:
    void value();
    void minimumValue();
    void maximumValue();
    void indeterminate();

private:
    QStringList standard;
    QString qmlSource;

    QDeclarativeComponent *component;
    QObject *componentObject;
    QDeclarativeEngine *engine;
};


tst_quickcomponentsscrolldecorator::tst_quickcomponentsscrolldecorator()
{
    QDeclarativeWindow *window = new QDeclarativeWindow();
    QDeclarativeComponent *component = new QDeclarativeComponent(window->engine());

    QFile file("tst_quickcomponentsscrolldecorator.qml");
    QVERIFY(file.open(QFile::ReadOnly));
    component->setData( file.readAll(), QUrl() );
    
    componentObject = component->create();
    QVERIFY(componentObject != 0);
}

void tst_quickcomponentsscrolldecorator::value()
{
    // check presence of property and set initial value
    QVERIFY( componentObject->setProperty( "minimumValue", 0.0 ) );
    QVERIFY( componentObject->setProperty( "maximumValue", 100.0 ) );
    QVERIFY( componentObject->setProperty( "value", 10.0 ) );
    QCOMPARE( componentObject->property("value").toReal(), 10.0 );
}

void tst_quickcomponentsscrolldecorator::minimumValue()
{
    // check presence of property and set initial value
    QVERIFY( componentObject->setProperty( "minimumValue", 0.0 ) );
    QCOMPARE( componentObject->property("minimumValue").toReal(), 0.0 );

    // try to set value below minimum, minimum is already 0
    componentObject->setProperty( "maximumValue", 100.0 );
    componentObject->setProperty( "value", 50.0 );
    componentObject->setProperty( "value", -1.0 );
    // the minimum limit should prevent change in property
    QEXPECT_FAIL("", "Not yet blocked by min and max ranges, http://bugreports.qt.nokia.com/browse/QTCOMPONENTS-287", Continue);
    QVERIFY( componentObject->property("value") == 50.0 );
}

void tst_quickcomponentsscrolldecorator::maximumValue()
{
    // check presence of property and set initial value
    QVERIFY( componentObject->setProperty( "maximumValue", 100.0 ) );
    QCOMPARE( componentObject->property("maximumValue").toReal(), 100.0 );

    // tro ty set value above maximum, maximum is already 100
    componentObject->setProperty( "minimumValue", 0.0 );
    componentObject->setProperty( "value", 50.0 );
    componentObject->setProperty( "value", 101.0 );
    // the maximum limit should prevent change in property
    QEXPECT_FAIL("", "Not yet blocked by min and max ranges, http://bugreports.qt.nokia.com/browse/QTCOMPONENTS-287", Continue);
    QVERIFY( componentObject->property("value") == 50.0 );
}

void tst_quickcomponentsscrolldecorator::indeterminate()
{
    // check presence of property and set initial value
    QVERIFY( componentObject->setProperty( "indeterminate", true ) );
    QCOMPARE( componentObject->property("indeterminate").toBool(), true );
}

QTEST_MAIN(tst_quickcomponentsscrolldecorator)

#include "tst_quickcomponentsscrolldecorator.moc"
