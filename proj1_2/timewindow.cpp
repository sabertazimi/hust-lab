#include <QString>
#include <time.h>
#include "timewindow.h"
#include <iostream>

using namespace std;

TimeWindow::TimeWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(400, 300));
    label = new QLabel(this);
    label->setText("Time = now");
}

QMainWindow &TimeWindow::setTime(const char *txt) {
    QString str(txt);
    cout << str.toLatin1().data() << endl;
    label->setText(str);
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
