#include <QString>
#include <QThread>
#include <winsock2.h>
#include <algorithm>
#include <sstream>
#include <string>
#include <list>
#include "responseserver.h"
#include "dragonwebserver.h"

using namespace std;

///
/// \brief DragonWebServer::DragonWebServer
/// \param parent
///
DragonWebServer::DragonWebServer(QObject *parent) : QObject(parent) {
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
    SOCKET srvSock;

    int nAddrLen = sizeof(sockaddr);

    ListCONN conList;		// 保存所有有效的会话SOCKET
    ListCONN::iterator itor;
    ListConErr conErrList;	// 保存所有失效的会话SOCKET
    ListConErr::iterator itor1;

    // for select (non-block)
    FD_SET rfds;
    FD_SET wfds;
    u_long uNonBlock;

    // 初始化 winsock
    nRC = WSAStartup(0x0101, &wsaData);
    if (nRC) {
        logRes(QString("Server initialize winsock error!\n"));
        return -1;
    }

    if (wsaData.wVersion != 0x0101) {
        logRes(QString("Server's winsock version error!\n"));
        WSACleanup();
        return -1;
    }

    logRes(QString("Server's winsock initialized !\n"));

    // 创建 TCP socket
    srvSock = socket(AF_INET, SOCK_STREAM, 0);
    if (srvSock == INVALID_SOCKET) {
        logRes(QString("Server create socket error!\n"));
        WSACleanup();
        return -1;
    }

    logRes(QString("Server TCP socket create OK!\n"));

    // 绑定 socket to Server's IP and port 80
    srvAddr.sin_family = AF_INET;
    srvAddr.sin_port = htons(SERVER_PORT);
    srvAddr.sin_addr.S_un.S_addr = INADDR_ANY;
    nRC = bind(srvSock, (LPSOCKADDR)&srvAddr, sizeof(srvAddr));
    if (nRC == SOCKET_ERROR) {
        logRes(QString("Server socket bind error!\n"));
        closesocket(srvSock);
        WSACleanup();
        return -1;
    }
    logRes(QString("Server socket bind OK!\n"));

    // 开始监听过程，等待客户的连接
    nRC = listen(srvSock, MAXCONN);
    if (nRC == SOCKET_ERROR) {
        logRes(QString("Server socket listen error!\n"));
        closesocket(srvSock);
        WSACleanup();
        return -1;
    }

    logRes(QString("Start to listen for http request!\n"));

    // 将srvSock设为非阻塞模式以监听客户连接请求
    uNonBlock = 1;
    ioctlsocket(srvSock, FIONBIO, &uNonBlock);
    int httpSocket = 0;

    while (true) {
        // 清空read, write套接字集合
        FD_ZERO(&rfds);
        FD_ZERO(&wfds);

        // 设置等待客户连接请求
        FD_SET(srvSock, &rfds);

        // 开始等待
        int nTotal = select(0, &rfds, &wfds, NULL, NULL);

        // 如果srvSock收到连接请求，接受客户连接请求
        if (FD_ISSET(srvSock, &rfds)) {
            nTotal--;

            // 产生会话SOCKET
            httpSocket++;
            stringstream ss;
            string s;
            ss << httpSocket;
            ss >> s;
            ss.flush();
            logRes(QString(string("Http Socket Num: " + s + "\n").c_str()));
            SOCKET connSock = accept(srvSock, (LPSOCKADDR)&clientAddr, &nAddrLen);

            if (connSock == INVALID_SOCKET) {
                logRes(QString("Server accept connection request error!\n"));
                break;
                // closesocket(srvSock);
                // WSACleanup();
                // return -1;
            }

            QThread *rsThread = new QThread;
            ResponseServer *rs = new ResponseServer(connSock);
            rs->moveToThread(rsThread);
            connect(rsThread, SIGNAL(started()), rs, SLOT(resolve()));
            connect(rsThread, SIGNAL(finished()), rsThread, SLOT(deleteLater()));
            connect(rs, SIGNAL(finished()), rs, SLOT(deleteLater()));
            connect(rs, SIGNAL(finished()), rsThread, SLOT(quit()));
            connect(rs, SIGNAL(rcvReq(QString)), this, SLOT(logReq(QString)));
            connect(rs, SIGNAL(sndRes(QString)), this, SLOT(logRes(QString)));
            rsThread->start();

            // 将产生的会话SOCKET保存在conList中
            conList.insert(conList.end(), connSock);
        }

        if (nTotal > 0) {
            // 检查所有有效的会话SOCKET是否有数据到来
            // 或是否可以发送数据
            for (itor = conList.begin(); itor != conList.end(); itor++) {
                // 如果会话SOCKET可以发送数据，
                // 则向客户发送消息
                //if (FD_ISSET(*itor, &wfds)) {
                //	// 如果发送缓冲区有内容，则发送
                //	if (strlen(sendBuf) > 0) {
                //		nRC = send(*itor, sendBuf, strlen(sendBuf), 0);
                //		if (nRC == SOCKET_ERROR) {
                //			// 发送数据错误，
                //			// 记录下产生错误的会话SOCKET
                //			conErrList.insert(conErrList.end(), *itor);
                //		}
                //		else {
                //			// 发送数据成功，清空发送缓冲区
                //			memset(sendBuf, '\0', BUFLEN);
                //		}
                //	}
                //}

                // 如果会话SOCKET有数据到来，则接受客户的数据
           }
        }
    }

    closesocket(srvSock);
    WSACleanup();
    emit finished();

    return 0;
}


void DragonWebServer::logReq(QString req) {
    emit rcvReq(req);
}

void DragonWebServer::logRes(QString res) {
    emit sndRes(res);
}
