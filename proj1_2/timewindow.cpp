#include <QString>
#include <ctime>
#include "timewindow.h"
#include <iostream>

using namespace std;

TimeWindow::TimeWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(400, 300));
    label = new QLabel(this);
    label->setFixedSize(220,50);
    label->setText("Time = now");
}

QMainWindow &TimeWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

const char* TimeWindow::getTime(void) {
    time_t ct;
    ct = time(NULL);
    return ctime(&ct);
}

TimeWindow::~TimeWindow(void)
{
    delete label;
}
