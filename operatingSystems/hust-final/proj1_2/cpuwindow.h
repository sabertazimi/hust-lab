#ifndef CPUWINDOW_H
#define CPUWINDOW_H

#include <QMainWindow>
#include <QLabel>

class CPUWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit CPUWindow(QWidget *parent = 0);
    ~CPUWindow(void);

private:
    QLabel *label;
    char *cpuTxt;
    QMainWindow &setText(const char *txt);
    const char* getCPU(void);

private slots:
    void updateCPU(void);
};

#endif // CPUWINDOW_H
