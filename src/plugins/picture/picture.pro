######################################################################
# Automatically generated by qmake (2.01a) Mon Nov 15 23:01:55 2010
######################################################################

include(../plugins.pri)

QT += declarative

HEADERS += pictureplugin.h \
           picturemodel.h \
           ../mediamodel.h

SOURCES += pictureplugin.cpp \
           picturemodel.cpp \
           ../mediamodel.cpp

INCLUDE += ../../3rdparty/libexif-0.6.19/libexif
LIBS += -L../../3rdparty/libexif-0.6.19/libexif/.libs -lexif
