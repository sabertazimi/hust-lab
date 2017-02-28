#ifndef CPUWINDOW_H
#define CPUWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <string>

using namespace std;

class CPUWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit CPUWindow(QWidget *parent = 0);
    ~CPUWindow(void);
    QMainWindow &setText(const char *txt);
    const char* getCPU(void);

private:
    QLabel *label;
};

#endif // CPUWINDOW_H
