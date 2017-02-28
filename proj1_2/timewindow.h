#ifndef TIMEWINDOW_H
#define TIMEWINDOW_H

#include <QMainWindow>
#include <QLabel>

class TimeWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit TimeWindow(QWidget *parent = 0);
    ~TimeWindow(void);
    QMainWindow &setText(const char *txt);
    const char* getTime(void);

private:
    QLabel *label;
};

#endif // TIMEWINDOW_H
