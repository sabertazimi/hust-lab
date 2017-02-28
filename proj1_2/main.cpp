#include "timewindow.h"
#include "cpuwindow.h"
#include "sumwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    TimeWindow tw;
    tw.setTime(tw.getTime());
    tw.show();
    CPUWindow cw;
    cw.show();
    SumWindow sw;
    sw.show();


    return a.exec();
}
