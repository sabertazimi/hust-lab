#ifndef SERVERWINDOW_H
#define SERVERWINDOW_H

#include <QMainWindow>
#include <QWidget>
#include <QLineEdit>
#include <QTableWidget>
#include <QString>
#include <QPushButton>
#include <list>
#include "dragonwebserver.h"

using namespace std;

///
/// \brief The ServerWindow class
///
class ServerWindow : public QMainWindow
{
    Q_OBJECT

public:
    ///
    /// \brief ServerWindow
    /// \param parent
    ///
    explicit ServerWindow(QWidget *parent = 0);
    ~ServerWindow(void);

public:
    QLineEdit *inputIP3;
    QLineEdit *inputIP2;
    QLineEdit *inputIP1;
    QLineEdit *inputIP0;
    QLineEdit *inputPort;
    QLineEdit *inputPath;
    QPushButton *fileBtn;
    ///
    /// \brief startBtn
    ///
    QPushButton *startBtn;
    ///
    /// \brief stopBtn
    ///
    QPushButton *stopBtn;
    ///
    /// \brief running
    ///
    bool running;

private:
    ///
    /// \brief mainWindow
    ///
    QWidget *mainWindow;
    QTableWidget *reqTab;
    QTableWidget *resTab;
    bool checkInput(void);
    ///
    /// \brief reqlogs
    ///
    list <QString> reqlogs;
    ///
    /// \brief reslogs
    ///
    list <QString> reslogs;
    ///
    /// \brief dwsThread
    ///
    QThread     *dwsThread;
    ///
    /// \brief dws
    ///
    DragonWebServer *dws;

public slots:
    void enableInput(void);
    void disableInput(void);

private slots:
    ///
    /// \brief updateServer
    ///
    void logReq(const QString &req);
    void logRes(const QString &res);
    void startBtnHandle(void);
    void stopBtnHandle(void);
    void fileBtnHandle(void);
};

#endif // SERVERWINDOW_H
