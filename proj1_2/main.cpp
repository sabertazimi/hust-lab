#include "timewindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    TimeWindow w;
    w.show();

    return a.exec();
}
