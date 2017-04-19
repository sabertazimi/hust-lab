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
#include <QMessageBox>
#include <QFileDialog>
#include <iostream>
#include <sstream>
#include <list>
#include <cstdio>
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

    this->inputIP3 = new QLineEdit(mainWindow);
    this->inputIP3->setText(QString("192"));
    this->inputIP2 = new QLineEdit(mainWindow);
    this->inputIP2->setText(QString("168"));
    this->inputIP1 = new QLineEdit(mainWindow);
    this->inputIP1->setText(QString("204"));
    this->inputIP0 = new QLineEdit(mainWindow);
    this->inputIP0->setText(QString("1"));
    QLabel *labelIP3 = new QLabel(QWidget::tr("&IP:"), mainWindow);
    QLabel *labelIP2 = new QLabel(QWidget::tr("&."), mainWindow);
    QLabel *labelIP1 = new QLabel(QWidget::tr("&."), mainWindow);
    QLabel *labelIP0 = new QLabel(QWidget::tr("&."), mainWindow);
    labelIP3->setBuddy(this->inputIP3);
    labelIP2->setBuddy(this->inputIP2);
    labelIP1->setBuddy(this->inputIP1);
    labelIP0->setBuddy(this->inputIP0);

    this->inputPort = new QLineEdit(mainWindow);
    this->inputPort->setText(QString("80"));
    QLabel *labelPort = new QLabel(QWidget::tr("&Port:"), mainWindow);
    labelPort->setBuddy(this->inputPort);

    this->inputPath = new QLineEdit(mainWindow);
    this->inputPath->setText(QString("C:\\dws"));
    QLabel *labelPath = new QLabel(QWidget::tr("&Path:"), mainWindow);
    labelPath->setBuddy(this->inputPath);
    this->fileBtn = new QPushButton(QWidget::tr("Browser"), this->mainWindow);
    connect(this->fileBtn, SIGNAL(released()), this, SLOT(fileBtnHandle()));

    topLayout->addStretch();
    topLayout->addWidget(labelIP3);
    topLayout->addWidget(this->inputIP3);
    topLayout->addWidget(labelIP2);
    topLayout->addWidget(this->inputIP2);
    topLayout->addWidget(labelIP1);
    topLayout->addWidget(this->inputIP1);
    topLayout->addWidget(labelIP0);
    topLayout->addWidget(this->inputIP0);
    topLayout->addStretch();
    topLayout->addWidget(labelPort);
    topLayout->addWidget(this->inputPort);
    topLayout->addStretch();
    topLayout->addWidget(labelPath);
    topLayout->addWidget(this->inputPath);
    topLayout->addWidget(this->fileBtn);
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
    delete this->inputIP3;
    delete this->inputIP2;
    delete this->inputIP1;
    delete this->inputIP0;
    delete this->inputPort;
    delete this->inputPath;
    delete this->fileBtn;
    delete this->mainWindow;
}

void ServerWindow::startBtnHandle(void) {
    if (this->running == false) {
        if (!this->checkInput()) {
            return;
        }

        this->running = true;
        this->disableInput();

        this->dwsThread = new QThread;
        this->dws = new DragonWebServer(this);
        this->dws->moveToThread(this->dwsThread);
        connect(this->dwsThread, SIGNAL(started()), this->dws, SLOT(runServer()));
        connect(this->dwsThread, SIGNAL(finished()), this->dwsThread, SLOT(deleteLater()));
        connect(this->dws, SIGNAL(finished()), this->dwsThread, SLOT(quit()));
        connect(this->dws, SIGNAL(finished()), this->dws, SLOT(deleteLater()));
        connect(this->dws, SIGNAL(finished()), this, SLOT(enableInput()));

        this->dwsThread->start();
        this->logReq("Server started");
        this->logRes("Server started");
    } else {
        QMessageBox::critical(NULL, "Error", "Server is runing!");
    }
}

void ServerWindow::stopBtnHandle(void) {
    if (this->running == true) {
        this->dws->stopServer();
        this->logReq("Server stoped");
        this->logRes("Server stoped");
    } else {
        QMessageBox::critical(NULL, "Error", "Server has been stoped!");
    }
}

void ServerWindow::fileBtnHandle(void) {
    QString path = QFileDialog::getExistingDirectory(this, tr("Open Directory"), "C:\\",
                                                     QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);

    this->inputPath->setText(path);
}

void ServerWindow::enableInput(void) {
    this->inputIP0->setEnabled(true);
    this->inputIP1->setEnabled(true);
    this->inputIP2->setEnabled(true);
    this->inputIP3->setEnabled(true);
    this->inputPort->setEnabled(true);
    this->inputPath->setEnabled(true);
    this->fileBtn->setEnabled(true);

    this->startBtn->setEnabled(true);
    this->stopBtn->setEnabled(false);
}

void ServerWindow::disableInput(void) {
    this->inputIP0->setEnabled(false);
    this->inputIP1->setEnabled(false);
    this->inputIP2->setEnabled(false);
    this->inputIP3->setEnabled(false);
    this->inputPort->setEnabled(false);
    this->inputPath->setEnabled(false);
    this->fileBtn->setEnabled(false);

    this->stopBtn->setEnabled(true);
    this->startBtn->setEnabled(false);

}

bool ServerWindow::checkInput(void) {
//    string ip3str = this->inputIP3->text().toLocal8Bit().constData();
//    string ip2str = this->inputIP2->text().toLocal8Bit().constData();
//    string ip1str = this->inputIP1->text().toLocal8Bit().constData();
//    string ip0str = this->inputIP0->text().toLocal8Bit().constData();

    string port = string(this->inputPort->text().toLocal8Bit().constData());
    string filePath = string(this->inputPath->text().toLocal8Bit().constData());

    if (port == "") {
        QMessageBox::critical(NULL, "Error", "Port can't be empty!");
        return false;
    }

    stringstream ss;
    int portNum;
    ss << port;
    ss >> portNum;

    // input port is NaN
    if (portNum == 0) {
        QMessageBox::critical(NULL, "Error", "Port can't be NaN or 0!");
        return false;
    }

    if (filePath == "") {
        QMessageBox::critical(NULL, "Error", "File path can't be empty!");
        return false;
    }

    return true;
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
