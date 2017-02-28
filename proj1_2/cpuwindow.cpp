#include <QString>
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
    
    // open /proc/stat
    proc_stat = fopen("/proc/stat","r");
    if (proc_stat == NULL) {
        exit(0);
    }
}

QMainWindow &CPUWindow::setText(const char *txt) {
    label->setText(QString(txt));
    return (*this);
}

const char* CPUWindow::getCPU(void) {
    char buf[50];
    int total = 0, idle = 0;
    
    fscanf(proc_stat, "%s", buf);
    
    for(int i = 0; i < 9; i++) {
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
    
    for (int i = 0; i < 9; i++) {
        fscanf(proc_stat, "%s", buf);
        total -= atoi(buf);
        
        // column 4: idle spare time
        if (i == 3) {
            idle-=atoi(buf);
        }    
    }
    
    sprintf(cpuTxt, "CPU Usage = %.2f%%\n", 100.0*((float)(total-idle)) / ((float)(total)));
    
    return cpuTxt;
}

CPUWindow::~CPUWindow(void)
{
    delete label;
    delete cpuTxt;
    fclose(proc_stat);
}
