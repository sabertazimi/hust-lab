#ifndef SUMWINDOW_H
#define SUMWINDOW_H

#include <QMainWindow>

namespace Ui {
class sumWindow;
}

class sumWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit sumWindow(QWidget *parent = 0);
    ~sumWindow();

private:
    Ui::sumWindow *ui;
};

#endif // SUMWINDOW_H
