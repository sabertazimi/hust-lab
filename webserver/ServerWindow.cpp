#include <QMainWindow>
#include <QWidget>
#include <QLayout>
#include <QMessageBox>
#include <QPushButton>
#include <QString>
#include <QTimer>
#include <QLabel>
#include <QDesktopWidget>
#include <QThread>
#include <iostream>
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

    this->mainWindow = new QWidget();

    QHBoxLayout *topLayout = new QHBoxLayout;
    this->startBtn = new QPushButton(QWidget::tr("Start"), this->mainWindow);
    this->stopBtn = new QPushButton(QWidget::tr("Stop"), this->mainWindow);
    connect(this->startBtn, SIGNAL(released()), this, SLOT(startBtnHandle()));
    connect(this->stopBtn, SIGNAL(released()), this, SLOT(stopBtnHandle()));
    topLayout->addStretch();
    topLayout->addWidget(this->startBtn);
    topLayout->addStretch();
    topLayout->addWidget(this->stopBtn);
    topLayout->addStretch();

    QHBoxLayout *bomLayout = new QHBoxLayout;
    this->label = new QLabel(this->mainWindow);
    this->label->setText("Welcome to Dragon Web Server");
    this->label->setFixedSize(dw.width() * 0.7, dw.height() * 0.7);
    bomLayout->addWidget(this->label);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addLayout(topLayout);
    mainLayout->addLayout(bomLayout);

    this->mainWindow->setLayout(mainLayout);
    this->setCentralWidget(this->mainWindow);
    this->setFixedSize(dw.width(), dw.height());

    this->running = false;

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
    delete this->startBtn;
    delete this->stopBtn;
    delete this->mainWindow;
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

    for (itor = this->reslogs.begin(); itor != this->reslogs.end(); itor++) {
        ret.append(*itor);
        ret.append("\n");
    }

    return ret;
}

void ServerWindow::startBtnHandle(void) {
    if (this->running == false) {
        this->running = true;

        this->dwsThread = new QThread;
        this->dws = new DragonWebServer(this);
        this->dws->moveToThread(this->dwsThread);
        connect(this->dwsThread, SIGNAL(started()), this->dws, SLOT(runServer()));
        connect(this->dwsThread, SIGNAL(finished()), this->dwsThread, SLOT(deleteLater()));
        connect(this->dws, SIGNAL(finished()), this->dwsThread, SLOT(quit()));
        connect(this->dws, SIGNAL(finished()), this->dws, SLOT(deleteLater()));
        connect(this->dws, SIGNAL(rcvReq(const QString &)), this, SLOT(logReq(const QString &)));
        connect(this->dws, SIGNAL(sndRes(const QString &)), this, SLOT(logRes(const QString &)));

        this->dwsThread->start();
    }
}

void ServerWindow::stopBtnHandle(void) {
    if (this->running == true) {
        this->running = false;
        this->dws->stopServer();
    }
}

void ServerWindow::logReq(const QString &req) {
    this->reqlogs.insert(reqlogs.end(), req);
    this->updateServer();
}

void ServerWindow::logRes(const QString &res) {
    this->reslogs.insert(reslogs.end(), res);
    this->updateServer();
}

///
/// \brief ServerWindow::updateServer
///
void ServerWindow::updateServer(void) {
    this->label->setText(getServer());
}
