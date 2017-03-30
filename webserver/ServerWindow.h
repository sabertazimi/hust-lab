#ifndef SERVERWINDOW_H
#define SERVERWINDOW_H

#include <QMainWindow>
#include <QWidget>
#include <QString>
#include <QTimer>
#include <QLabel>
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
    ///
    /// \brief label
    ///
    QLabel *label;
    ///
    /// \brief startBtn
    ///
    QPushButton *startBtn;
    ///
    /// \brief stopBtn
    ///
    QPushButton *stopBtn;
    ///
    /// \brief timer
    ///
    QTimer *timer;
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
    ///
    /// \brief getServer
    /// \return
    ///
    QString getServer(void);
    ///
    /// \brief setText
    /// \param txt
    /// \return
    ///
    QMainWindow &setText(QString msg);

private slots:
    ///
    /// \brief updateServer
    ///
    void updateServer(void);
    void logReq(QString req);
    void logRes(QString res);
    void startBtnHandle(void);
    void stopBtnHandle(void);
};

#endif // SERVERWINDOW_H
