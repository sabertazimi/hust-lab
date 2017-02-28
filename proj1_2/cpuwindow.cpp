#include <QString>
#include "cpuwindow.h"

CPUWindow::CPUWindow(QWidget *parent) : QMainWindow(parent)
{
    label = new QLabel(this);
    label->setText("CPU Usage = 0%");
}

QMainWindow &CPUWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

CPUWindow::~CPUWindow()
{
    delete label;
}
