#ifndef SERVERWINDOW_H
#define SERVERWINDOW_H

#include <QMainWindow>
#include <QString>
#include <QTimer>
#include <QLabel>

class ServerWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit ServerWindow(QWidget *parent = 0);
    ~ServerWindow(void);

private:
    QLabel *label;
    QTimer *timer;
    QString getServer(void);
    QMainWindow &setText(const char *txt);

private slots:
    void updateServer(void);
};

#endif // SERVERWINDOW_H
