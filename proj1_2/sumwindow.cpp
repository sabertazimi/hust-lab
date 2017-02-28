#include <QString>
#include <cstdio>
#include "sumwindow.h"

using namespace std;

SumWindow::SumWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(800, 300));
    label = new QLabel(this);
    label->setText("Sum = 0");
    label->setFixedSize(220,100);
    sum = 0;
    cnt = 0;
    sumTxt = new char[10];
}

QMainWindow &SumWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

const char *SumWindow::getSum(void) {
    if (cnt <= 1000) {
        sum += (++cnt);
        sprintf(sumTxt,"%d", sum);
    }
    
    return sumTxt;
}

SumWindow::~SumWindow(void)
{
    delete label;
    delete sumTxt;
}
