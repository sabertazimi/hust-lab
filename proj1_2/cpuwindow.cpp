#include <QString>
#include "cpuwindow.h"

CPUWindow::CPUWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(600, 300));
    label = new QLabel(this);
    label->setText("CPU Usage = 0%");
}

QMainWindow &CPUWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

const char* CPUWindow::getCPU(void) {
    return NULL;
}

CPUWindow::~CPUWindow(void)
{
    delete label;
}
