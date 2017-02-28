#ifndef CPUWINDOW_H
#define CPUWINDOW_H

#include <QMainWindow>

namespace Ui {
class cpuWindow;
}

class cpuWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit cpuWindow(QWidget *parent = 0);
    ~cpuWindow();

private:
    Ui::cpuWindow *ui;
};

#endif // CPUWINDOW_H
