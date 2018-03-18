#include <QApplication>
#include <unistd.h>
#include <sys/wait.h>
#include "timewindow.h"
#include "cpuwindow.h"
#include "sumwindow.h"

int main(int argc, char *argv[])
{
    pid_t tw_t, cw_t, sw_t;

    while ((tw_t = fork()) == -1);

    if (tw_t == 0) {
        QApplication ta(argc, argv);
        TimeWindow tw;
        tw.show();
        ta.exec();
    } else {
        while ((cw_t = fork()) == -1);

        if (cw_t == 0) {
            QApplication tc(argc, argv);
            CPUWindow cw;
            cw.show();
            tc.exec();
        } else {
            while ((sw_t = fork()) == -1);

            if (sw_t == 0) {
                QApplication ts(argc, argv);
                SumWindow sw;
                sw.show();
                ts.exec();
            } else {
                for (int i = 0; i < 3; i++) {
                    waitpid(-1, NULL, 0);
                }
            }
        }
    }

}
