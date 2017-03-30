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

private:
    ///
    /// \brief running
    ///
    bool running;
    ///
    /// \brief mainWindow
    ///
    QWidget *mainWindow;
    QLineEdit *inputIP;
    QLineEdit *inputPort;
    QLineEdit *inputPath;
    QTableWidget *reqTab;
    QTableWidget *resTab;
    ///
    /// \brief startBtn
    ///
    QPushButton *startBtn;
    ///
    /// \brief stopBtn
    ///
    QPushButton *stopBtn;
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

private slots:
    ///
    /// \brief updateServer
    ///
    void logReq(const QString &req);
    void logRes(const QString &res);
    void startBtnHandle(void);
    void stopBtnHandle(void);
};

#endif // SERVERWINDOW_H
