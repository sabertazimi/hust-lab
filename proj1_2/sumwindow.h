#ifndef SUMWINDOW_H
#define SUMWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <string>

using namespace std;

class SumWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit SumWindow(QWidget *parent = 0);
    ~SumWindow(void);
    QMainWindow &setText(const char *txt);

private:
    QLabel *label;
};

#endif // SUMWINDOW_H
