#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QWidget>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QLabel>
#include <QPushButton>
#include <QTabWidget>
#include <QMessageBox>
#include <QTableWidget>
#include <visitor.h>

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

    QTabWidget *adminTab;
    QPushButton *adminFlightButton;
    QPushButton *adminSeatButton;

    QTabWidget *visitorTab;
    QWidget *visPurchaseWindow;
    QLineEdit *visPurchaseStartEdit;
    QLineEdit *visPurchaseEndEdit;
    QLabel *visPurchaseStartLabel;
    QLabel *visPurchaseEndLabel;
    QTableWidget *visPurchaseTable;
    QPushButton *visPurchaseButton;
    QHBoxLayout *visPurchaseTopLayout;
    QHBoxLayout *visPurchaseBottomLayout;
    QVBoxLayout *visPurchaseMainLayout;
    QWidget *visFetchWindow;
    QPushButton *visFetchButton;
    QWidget *visCancelWindow;
    QPushButton *visCancelButton;
    QWidget *visBillingWindow;
    QWidget *visQueryWindow;
    QPushButton *visQueryButton;

    Visitor *visitor;

    void createLoginView(void);

    MainWindow *createAdminView(void);

    MainWindow *createVisitorView(void);
    MainWindow *createVisPurchaseWindow(void);
    MainWindow *createVisFetchWindow(void);
    MainWindow *createVisCancelWindow(void);
    MainWindow *createVisBillingWindow(void);
    MainWindow *createVisQueryWindow(void);

    inline void showMsgBox(const QString &icon, const QString &title = "Error", const QString &text = "Error") const {
        QMessageBox errorMsg;
        errorMsg.setIconPixmap(QPixmap(icon).scaled(20, 20));
        errorMsg.setWindowTitle(title);
        errorMsg.setText(text);
        errorMsg.exec();
    }

private slots:
    void onLoginVisitorButton(void);
    void onLoginAdminButton(void);
    void onVisPurchaseButton(void);
};

#endif // MAINWINDOW_H
