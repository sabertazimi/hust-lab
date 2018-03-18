#include <QString>
#include <QTimer>
#include <ctime>
#include "timewindow.h"

using namespace std;

TimeWindow::TimeWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(400, 300));
    label = new QLabel(this);
    label->setFixedSize(220,50);
    label->setText("Time = now");

    // using slots to implement update
    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateTime()));
    timer->start(1000);
}

TimeWindow::~TimeWindow(void)
{
    delete label;
}

const char* TimeWindow::getTime(void) {
    time_t ct;
    ct = time(NULL);
    return ctime(&ct);
}

void TimeWindow::updateTime(void) {
    label->setText(QString(getTime()));
}
