#include <QString>
#include "sumwindow.h"

SumWindow::SumWindow(QWidget *parent) : QMainWindow(parent)
{
    label = new QLabel(this);
    label->setText("Sum = 0");
}

QMainWindow &SumWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

SumWindow::~SumWindow()
{
    delete label;
}
