#include <QMainWindow>
#include <QLayout>
#include <QWidget>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QTableWidget>
#include <QString>
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
    QLabel *labelIP = new QLabel(QWidget::tr("&IP:"), mainWindow);
    this->inputIP = new QLineEdit(mainWindow);
    this->inputIP->setText(QString("192.168.191.1"));
    // @TODO
    this->inputIP->setEnabled(false);
    labelIP->setBuddy(this->inputIP);
    QLabel *labelPort = new QLabel(QWidget::tr("&Port:"), mainWindow);
    this->inputPort = new QLineEdit(mainWindow);
    this->inputPort->setText(QString("80"));
    labelPort->setBuddy(this->inputPort);
    QLabel *labelPath = new QLabel(QWidget::tr("&Path:"), mainWindow);
    this->inputPath = new QLineEdit(mainWindow);
    this->inputPath->setText(QString("C:\\dws"));
    labelPath->setBuddy(this->inputPath);
    topLayout->addStretch();
    topLayout->addWidget(labelIP);
    topLayout->addWidget(this->inputIP);
    topLayout->addStretch();
    topLayout->addWidget(labelPort);
    topLayout->addWidget(this->inputPort);
    topLayout->addStretch();
    topLayout->addWidget(labelPath);
    topLayout->addWidget(this->inputPath);
    topLayout->addStretch();

    QHBoxLayout *midLayout = new QHBoxLayout;
    this->startBtn = new QPushButton(QWidget::tr("Start"), this->mainWindow);
    this->stopBtn = new QPushButton(QWidget::tr("Stop"), this->mainWindow);
    connect(this->startBtn, SIGNAL(released()), this, SLOT(startBtnHandle()));
    connect(this->stopBtn, SIGNAL(released()), this, SLOT(stopBtnHandle()));
    midLayout->addStretch();
    midLayout->addWidget(this->startBtn);
    midLayout->addStretch();
    midLayout->addWidget(this->stopBtn);
    midLayout->addStretch();

    QHBoxLayout *bomLayout = new QHBoxLayout;
    this->reqTab = new QTableWidget(1, 1);
    this->reqTab->setWindowTitle("Req Logs");
    this->reqTab->resize(this->reqTab->maximumWidth(), this->reqTab->maximumHeight());
    this->reqTab->setItem(0, 0, new QTableWidgetItem("Welcome to Dragon Web Server"));
    this->reqTab->resizeColumnsToContents();
    this->reqTab->resizeRowsToContents();
    this->resTab = new QTableWidget(1, 1);
    this->resTab->setWindowTitle("Res Logs");
    this->resTab->resize(this->resTab->maximumWidth(), this->resTab->maximumHeight());
    this->resTab->setItem(0, 0, new QTableWidgetItem("Welcome to Dragon Web Server"));
    this->resTab->resizeColumnsToContents();
    this->resTab->resizeRowsToContents();
    bomLayout->addStretch();
    bomLayout->addWidget(this->reqTab);
    bomLayout->addStretch();
    bomLayout->addWidget(this->resTab);
    bomLayout->addStretch();

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addLayout(topLayout);
    mainLayout->addLayout(midLayout);
    mainLayout->addLayout(bomLayout);

    this->mainWindow->setLayout(mainLayout);
    this->setCentralWidget(this->mainWindow);
    this->resize(dw.width(), dw.height());

    this->running = false;
}

///
/// \brief ServerWindow::~ServerWindow
///
ServerWindow::~ServerWindow(void) {
    delete this->reqTab;
    delete this->resTab;
    delete this->startBtn;
    delete this->stopBtn;
    delete this->inputIP;
    delete this->inputPort;
    delete this->inputPath;
    delete this->mainWindow;
}

void ServerWindow::startBtnHandle(void) {
    if (this->running == false) {
        this->running = true;

        this->inputIP->setEnabled(false);
        this->inputPort->setEnabled(false);
        this->inputPath->setEnabled(false);
        this->startBtn->setEnabled(false);
        this->stopBtn->setEnabled(true);

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

        // @TODO
        this->inputIP->setEnabled(false);
        this->inputPort->setEnabled(true);
        this->inputPath->setEnabled(true);
        this->startBtn->setEnabled(true);
        this->stopBtn->setEnabled(false);

        this->dws->stopServer();
    }
}

void ServerWindow::logReq(const QString &req) {
    this->reqlogs.insert(reqlogs.end(), req);
    int cnt = this->reqTab->rowCount();
    this->reqTab->insertRow(cnt);
    this->reqTab->setItem(cnt,0,new QTableWidgetItem(this->reqlogs.back()));
    this->reqTab->resizeColumnsToContents();
    this->reqTab->resizeRowsToContents();
}

void ServerWindow::logRes(const QString &res) {
    this->reslogs.insert(reslogs.end(), res);
    int cnt = this->resTab->rowCount();
    this->resTab->insertRow(cnt);
    this->resTab->setItem(cnt,0,new QTableWidgetItem(this->reslogs.back()));
    this->resTab->resizeColumnsToContents();
    this->resTab->resizeRowsToContents();
}
