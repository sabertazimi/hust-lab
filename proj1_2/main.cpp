#include "timewindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    TimeWindow tw;
    tw.show();

    return a.exec();
}
