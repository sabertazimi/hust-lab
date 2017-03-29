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
    QDesktopWidget dw;

    this->setFixedSize(dw.width(), dw.height());

    this->label = new QLabel(this);
    this->label->setText("Welcome to Dragon Web Server");
    this->label->setFixedSize(dw.width(), dw.height());

    this->dwsThread = new QThread;
    this->dws = new DragonWebServer();
    this->dws->moveToThread(this->dwsThread);
    connect(this->dwsThread, SIGNAL(started()), this->dws, SLOT(runServer()));
    connect(this->dwsThread, SIGNAL(finished()), this->dwsThread, SLOT(deleteLater()));
    connect(this->dws, SIGNAL(finished()), this->dwsThread, SLOT(quit()));
    connect(this->dws, SIGNAL(finished()), this->dws, SLOT(deleteLater()));
    connect(this->dws, SIGNAL(rcvReq(QString)), this, SLOT(logReq(QString)));
    this->dwsThread->start();

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
    delete this->label;
    delete this->timer;
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
    this->label->setText(getServer());
}
