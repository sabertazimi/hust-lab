#include <QString>
#include "timewindow.h"
#include "ui_timewindow.h"

TimeWindow::TimeWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::TimeWindow)
{
    ui->setupUi(this);
    label = new QLabel(this);
    label->setText("Time = now");
}

QMainWindow &TimeWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

TimeWindow::~TimeWindow()
{
    delete label;
    delete ui;
}
