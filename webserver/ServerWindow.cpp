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
    this->reqLabel = new QLabel(this->mainWindow);
    this->reqLabel->setText("Welcome to Dragon Web Server");
    this->reqLabel->setFixedSize(dw.width() * 0.5, dw.height() * 0.7);
    this->resLabel = new QLabel(this->mainWindow);
    this->resLabel->setText("Welcome to Dragon Web Server");
    this->resLabel->setFixedSize(dw.width() * 0.5, dw.height() * 0.7);
    bomLayout->addStretch();
    bomLayout->addWidget(this->reqLabel);
    bomLayout->addStretch();
    bomLayout->addWidget(this->resLabel);
    bomLayout->addStretch();

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
    delete this->reqLabel;
    delete this->resLabel;
    delete this->startBtn;
    delete this->stopBtn;
    delete this->mainWindow;
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
    this->reqLabel->setText(this->getReqLogs());
}

void ServerWindow::logRes(const QString &res) {
    this->reslogs.insert(reslogs.end(), res);
    this->resLabel->setText(this->getResLogs());
}

QString ServerWindow::getReqLogs(void) {
    QString ret;
    list<QString>::iterator itor;

    for (itor = this->reqlogs.begin(); itor != this->reqlogs.end(); itor++) {
        ret.append(*itor);
        ret.append("\n");
    }

    return ret;
}

QString ServerWindow::getResLogs(void) {
    QString ret;
    list<QString>::iterator itor;

    for (itor = this->reslogs.begin(); itor != this->reslogs.end(); itor++) {
        ret.append(*itor);
        ret.append("\n");
    }

    return ret;
}
