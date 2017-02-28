#-------------------------------------------------
#
# Project created by QtCreator 2017-02-28T08:26:07
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = multi-windows
TEMPLATE = app


SOURCES += main.cpp\
        timewindow.cpp \
    cpuwindow.cpp \
    sumwindow.cpp

HEADERS  += timewindow.h \
    cpuwindow.h \
    sumwindow.h

FORMS    += timewindow.ui \
    cpuwindow.ui \
    sumwindow.ui
