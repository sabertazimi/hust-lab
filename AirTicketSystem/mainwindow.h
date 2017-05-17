#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QWidget>
#include <QWidget>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QLabel>
#include <QPushButton>

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();
private:
    QWidget *loginMainWindow;
    QVBoxLayout *loginMainLayout;
    QGridLayout *loginTopLayout;
    QHBoxLayout *loginBottomLayout;
    QLineEdit *loginIDEdit;
    QLineEdit *loginNameEdit;
    QLineEdit *loginPasswordEdit;
    QLabel *loginIDLabel;
    QLabel *loginNameLabel;
    QLabel *loginPasswordLabel;
    QPushButton *loginVisitorButton;
    QPushButton *loginAdminButton;

    MainWindow &createLoginView(void);
};

#endif // MAINWINDOW_H
