#include "timewindow.h"
#include "cpuwindow.h"
#include "sumwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    TimeWindow tw;
    tw.setText(tw.getTime());
    tw.show();
    CPUWindow cw;
    cw.setText(cw.getCPU());
    cw.show();
    // SumWindow sw;
    // sw.show();


    return a.exec();
}
