#include <QMainWindow>
#include <QMessageBox>
#include <QString>
#include <QTimer>
#include <QLabel>
#include <QDesktopWidget>
#include <QThread>
#include <list>
#include "dragonwebserver.h"
#include "serverwindow.h"

using namespace std;

///
/// \brief ServerWindow::ServerWindow
/// \param parent
///
ServerWindow::ServerWindow(QWidget *parent) : QMainWindow(parent) {
    QThread     *dwsThread;
    DragonWebServer *dws;
    QDesktopWidget dw;

    this->setFixedSize(dw.width(), dw.height());

    label = new QLabel(this);
    label->setText("Welcome to Dragon Web Server");
    label->setFixedSize(dw.width(), dw.height());

    dwsThread = new QThread;
    dws = new DragonWebServer();
    dws->moveToThread(dwsThread);
    connect(dwsThread, SIGNAL(started()), dws, SLOT(runServer()));
    connect(dwsThread, SIGNAL(finished()), dwsThread, SLOT(deleteLater()));
    connect(dws, SIGNAL(finished()), dwsThread, SLOT(quit()));
    connect(dws, SIGNAL(finished()), dws, SLOT(deleteLater()));
    connect(dws, SIGNAL(rcvReq(QString)), this, SLOT(logReq(QString)));
    dwsThread->start();

    // using slots to implement update
    // timer = new QTimer(this);
    // connect(timer, SIGNAL(timeout()), this, SLOT(updateServer()));
    // timer->start(2000);
    // QMessageBox::critical(this, "Error", "Restart to fix unkown error!");
}

///
/// \brief ServerWindow::~ServerWindow
///
ServerWindow::~ServerWindow(void) {
    delete label;
    delete timer;
}

///
/// \brief ServerWindow::getServer
/// \return
///
QString ServerWindow::getServer(void) {
    QString ret;
    list<QString>::iterator itor;

    for (itor = this->reqlogs.begin(); itor != this->reqlogs.end(); itor++) {
        ret.append(*itor);
        ret.append("\n");
    }

    return ret;
}

void ServerWindow::logReq(QString req) {
    this->reqlogs.insert(reqlogs.end(), req);
    this->updateServer();
}

///
/// \brief ServerWindow::updateServer
///
void ServerWindow::updateServer(void) {
    label->setText(getServer());
}
