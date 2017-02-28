#include <QString>
#include "sumwindow.h"

SumWindow::SumWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(800, 300));
    label = new QLabel(this);
    label->setText("Sum = 0");
}

QMainWindow &SumWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

SumWindow::~SumWindow(void)
{
    delete label;
}
