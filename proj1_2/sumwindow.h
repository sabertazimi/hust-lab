#ifndef SUMWINDOW_H
#define SUMWINDOW_H

#include <QMainWindow>
#include <QLabel>

class SumWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit SumWindow(QWidget *parent = 0);
    ~SumWindow(void);

private:
    QLabel *label;
    int sum;
    int cnt;
    char *sumTxt;
    QMainWindow &setText(const char *txt);
    const char *getSum(void);

private slots:
    void updateSum(void);
};

#endif // SUMWINDOW_H
