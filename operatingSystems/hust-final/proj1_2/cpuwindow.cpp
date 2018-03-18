#include <QString>
#include <QTimer>
#include <cstdio>
#include <unistd.h>
#include "cpuwindow.h"

using namespace std;

CPUWindow::CPUWindow(QWidget *parent) : QMainWindow(parent)
{
    move(QPoint(600, 300));
    label = new QLabel(this);
    label->setText("CPU Usage = 0%");
    label->setFixedSize(220,50);
    cpuTxt = new char[10];

    // using slots to implement update
    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateCPU()));
    timer->start(2000);
}

CPUWindow::~CPUWindow(void)
{
    delete label;
    delete cpuTxt;
}

const char* CPUWindow::getCPU(void) {
    FILE *proc_stat = NULL;
    char buf[50];
    int total = 0, idle = 0;

    // open /proc/stat
    proc_stat = fopen("/proc/stat","r");
    if (proc_stat == NULL) {
        exit(0);
    }

    fscanf(proc_stat, "%s", buf);
    
    for(int i = 0; i < 10; i++) {
        fscanf(proc_stat, "%s", buf);
        total += atoi(buf);
        
        // column 4: idle spare time
        if (i == 3) {
            idle = atoi(buf);
        }
    }
    
    fseek(proc_stat, 0, SEEK_SET);  // reset seek pointer to 0 (read file again)
    sleep(1);   // update cpu stat
    fscanf(proc_stat, "%s", buf);
    
    for (int i = 0; i < 10; i++) {
        fscanf(proc_stat, "%s", buf);
        total -= atoi(buf);
        
        // column 4: idle spare time
        if (i == 3) {
            idle-=atoi(buf);
        }    
    }
    
    fclose(proc_stat);

    sprintf(cpuTxt, "CPU Usage = %.2f%%\n", 100.0*((float)(idle-total)) / ((float)(-total)));

    return cpuTxt;
}

void CPUWindow::updateCPU(void) {
    label->setText(QString(getCPU()));
}
