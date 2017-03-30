#include <QString>
#include <QThread>
#include <winsock2.h>
#include <algorithm>
#include <sstream>
#include <iostream>
#include <string>
#include <list>
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
    // this->setIP("191.168.191.1");
    this->setPort(SERVER_PORT);
    this->setPath(QString("C:\\dws"));
}

DragonWebServer::~DragonWebServer(void) {
}

///
/// \brief DragonWebServer::setOptions
/// \param dwsopt
/// \return
///
DragonWebServer &DragonWebServer::setOptions(dwsOptions dwsopt) {
    this->setIP(dwsopt.ip);
    this->setPort(dwsopt.port);
    this->setPath(dwsopt.filePath);
    return *this;
}

///
/// \brief DragonWebServer::setIP
/// \param ip
/// \return
///
DragonWebServer &DragonWebServer::setIP(QString ip) {
    this->dwsopt.ip = ip;
    return *this;
}

///
/// \brief DragonWebServer::setPort
/// \param port
/// \return
///
DragonWebServer &DragonWebServer::setPort(int port) {
    this->dwsopt.port = port;
    return *this;
}

///
/// \brief DragonWebServer::setPath
/// \param filePath
/// \return
///
DragonWebServer &DragonWebServer::setPath(QString filePath) {
    this->dwsopt.filePath = filePath;
    return *this;
}

///
/// \brief DragonWebServer::runServer
/// \param dwsopt
/// \return
///
int DragonWebServer::runServer(void) {
    WSADATA wsaData;
    int nRC;

    sockaddr_in srvAddr;
    sockaddr_in clientAddr;

    int nAddrLen = sizeof(sockaddr);

    // 初始化 winsock
    nRC = WSAStartup(0x0101, &wsaData);
    if (nRC) {
        emit finished();
        return -1;
    }

    if (wsaData.wVersion != 0x0101) {
        WSACleanup();
        emit finished();
        return -1;
    }

    // 创建 TCP socket
    this->srvSock = socket(AF_INET, SOCK_STREAM, 0);
    if (this->srvSock == INVALID_SOCKET) {
        WSACleanup();
        emit finished();
        return -1;
    }

    // 绑定 socket to Server's IP and port 80
    srvAddr.sin_family = AF_INET;
    srvAddr.sin_port = htons(SERVER_PORT);
    srvAddr.sin_addr.S_un.S_addr = INADDR_ANY;
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
            ResponseServer *rs = new ResponseServer(connSock);
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
    emit this->finished();
}

void DragonWebServer::dwsLogReq(const QString &req) {
    emit rcvReq(req);
    this->runServer();
    cout << "DragonWebServer: " << req.toLocal8Bit().constData() << endl;
}

void DragonWebServer::dwsLogRes(const QString &res) {
    emit sndRes(res);
    this->runServer();
    cout << "DragonWebServer: " << res.toLocal8Bit().constData() << endl;
}
