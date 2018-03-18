#include <QMessageBox>
#include <QString>
#include <QThread>
#include <winsock2.h>
#include <algorithm>
#include <sstream>
#include <iostream>
#include <string>
#include <list>
#include <cstdio>
#include "serverwindow.h"
#include "responseserver.h"
#include "dragonwebserver.h"

using namespace std;

///
/// \brief DragonWebServer::DragonWebServer
/// \param parent
///
DragonWebServer::DragonWebServer(ServerWindow *ui, QObject *parent) : QObject(parent) {
    this->ui = ui;
}

DragonWebServer::~DragonWebServer(void) {
}

DragonWebServer &DragonWebServer::setConfigFromUI(void) {
    this->setIP()
        .setPort(this->ui->inputPort->text().toLocal8Bit().constData())
        .setPath(this->ui->inputPath->text().toLocal8Bit().constData());
    return *this;
}

///
/// \brief DragonWebServer::setIP
/// \param ip
/// \return
///
DragonWebServer &DragonWebServer::setIP(void) {
    int ip3 = atoi(this->ui->inputIP3->text().toLocal8Bit().constData());
    int ip2 = atoi(this->ui->inputIP2->text().toLocal8Bit().constData());
    int ip1 = atoi(this->ui->inputIP1->text().toLocal8Bit().constData());
    int ip0 = atoi(this->ui->inputIP0->text().toLocal8Bit().constData());
    this->ip = (ip3 << 24) | (ip2 << 16) | (ip1 << 8) | ip0;
    return *this;
}

///
/// \brief DragonWebServer::setPort
/// \param port
/// \return
///
DragonWebServer &DragonWebServer::setPort(string port) {
    stringstream ss;
    int portNum;
    ss << port;
    ss >> portNum;
    this->port = portNum;
    return *this;
}

///
/// \brief DragonWebServer::setPath
/// \param filePath
/// \return
///
DragonWebServer &DragonWebServer::setPath(string filePath) {
    this->filePath = filePath;
    return *this;
}

///
/// \brief DragonWebServer::runServer
/// \return
///
int DragonWebServer::runServer(void) {
    this->setConfigFromUI();

    WSADATA wsaData;
    int nRC;

    sockaddr_in srvAddr;
    sockaddr_in clientAddr;

    int nAddrLen = sizeof(sockaddr);

    // 初始化 winsock
    nRC = WSAStartup(0x0101, &wsaData);
    if (nRC) {
        this->ui->running = false;
        emit finished();
        return -1;
    }

    if (wsaData.wVersion != 0x0101) {
        WSACleanup();
        this->ui->running = false;
        emit finished();
        return -1;
    }

    // 创建 TCP socket
    this->srvSock = socket(AF_INET, SOCK_STREAM, 0);
    if (this->srvSock == INVALID_SOCKET) {
        WSACleanup();
        this->ui->running = false;
        emit finished();
        return -1;
    }

    // 绑定 socket to Server's IP and port 80
    srvAddr.sin_family = AF_INET;
    srvAddr.sin_port = htons(this->port);
    srvAddr.sin_addr.S_un.S_addr = htonl(this->ip);
    nRC = bind(this->srvSock, (LPSOCKADDR)&srvAddr, sizeof(srvAddr));
    if (nRC == SOCKET_ERROR) {
        this->stopServer();
        return -1;
    }

    // 开始监听过程，等待客户的连接
    nRC = listen(this->srvSock, MAXCONN);
    if (nRC == SOCKET_ERROR) {
        this->stopServer();
        return -1;
    }

    FD_SET rfds;
    FD_SET wfds;
    u_long uNonBlock = 1;

    ioctlsocket(srvSock, FIONBIO, &uNonBlock);

    while (true) {
        //清空read,write套接字集合
        FD_ZERO(&rfds);
        FD_ZERO(&wfds);

        //设置等待客户连接请求
        FD_SET(srvSock,&rfds);


        //开始等待
        select(0, &rfds, &wfds, NULL, NULL);

        //如果srvSock收到连接请求，接受客户连接请求
        if (FD_ISSET(srvSock,&rfds)) {
            // 产生会话SOCKET
            SOCKET connSock = accept(this->srvSock, (LPSOCKADDR)&clientAddr, &nAddrLen);

            if (connSock == INVALID_SOCKET) {
                break;
                // closesocket(this->srvSock);
                // WSACleanup();
                // return -1;
            }

            QThread *rsThread = new QThread;
            ResponseServer *rs = new ResponseServer(connSock, this->filePath);
            rs->moveToThread(rsThread);
            connect(rsThread, SIGNAL(started()), rs, SLOT(resolve()));
            connect(rsThread, SIGNAL(finished()), rsThread, SLOT(deleteLater()));
            connect(rs, SIGNAL(finished()), rsThread, SLOT(quit()));
            connect(rs, SIGNAL(finished()), rs, SLOT(deleteLater()));
            connect(rs, SIGNAL(rsRcvReq(const QString &)), this->ui, SLOT(logReq(const QString &)));
            connect(rs, SIGNAL(rsSndRes(const QString &)), this->ui, SLOT(logRes(const QString &)));
            rsThread->start();
        }
    }

    this->stopServer();

    return 0;
}

void DragonWebServer::stopServer(void) {
    closesocket(this->srvSock);
    WSACleanup();
    this->ui->running = false;
    emit this->finished();
}
