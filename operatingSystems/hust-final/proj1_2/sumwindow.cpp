#include <QString>
#include <QTimer>
#include <cstdio>
#include "sumwindow.h"

using namespace std;

SumWindow::SumWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(800, 300));
    label = new QLabel(this);
    label->setText("Sum = 0");
    label->setFixedSize(220,50);
    sum = 0;
    cnt = 0;
    sumTxt = new char[10];

    // using slots to implement update
    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateSum()));
    timer->start(3000);
}

SumWindow::~SumWindow(void)
{
    delete label;
    delete sumTxt;
}

const char *SumWindow::getSum(void) {
    if (cnt <= 1000) {
        sum += (++cnt);
        sprintf(sumTxt,"%d", sum);
    }
    
    return sumTxt;
}

void SumWindow::updateSum(void) {
    label->setText(QString(getSum()));
}
