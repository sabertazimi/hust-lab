#include <QString>
#include <winsock2.h>
#include <sstream>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include "responseserver.h"

using namespace std;

///
/// \brief ResponseServer::ResponseServer
/// \param sock
/// \param parent
///
ResponseServer::ResponseServer(SOCKET sock, QObject *parent) : QObject(parent) {
    this->sock = sock;
    this->clearResData();
}

///
/// \brief ResponseServer::~ResponseServer
///
ResponseServer::~ResponseServer(void) {
}

///
/// \brief ResponseServer::split
/// \param s
/// \param delim
/// \return
///
vector<string> ResponseServer::split(const std::string &s, char delim) {
    vector<string> elems;
    stringstream ss;
    ss.str(s);
    string item;

    while (getline(ss, item, delim)) {
        elems.push_back(item);
    }

    return elems;
}

///
/// \brief ResponseServer::parseURL
/// \param url
/// \return
///
string ResponseServer::parseURL(string url) {
    vector<string> splitURL = this->split(url, '/');
    return splitURL[splitURL.size()-1];
}

void ResponseServer::setResVersion(string version) {
    if (version == "1.1") {
        this->resVersion = "HTTP/1.1";
    }
}

void ResponseServer::setResStatus(string statusCode) {
    if (statusCode == "200") {
        this->resStatus = "200 OK";
    }
}

void ResponseServer::appendResField(string key, string value) {
    (this->resHeaderFields).push_back(key + string(": ") + value);
}

void ResponseServer::clearResData(void) {
    this->resVersion = "";
    this->resStatus = "";
    this->resHeaderFields.clear();
    this->resBody = "";
}

string ResponseServer::getResData(void) {
    string resData = this->resVersion + " " + this->resStatus + "\n";

    for (int i = 0, size = (this->resHeaderFields).size(); i < size; i++) {
        resData += (this->resHeaderFields)[i];
    }

    resData += "\n" + this->resBody;

    return resData;
}

///
/// \brief ResponseServer::resBadRequest
///
void ResponseServer::resBadRequest(void) {
    this->clearResData();
}

///
/// \brief ResponseServer::resNotFound
///
void ResponseServer::resNotFound(void) {
    this->clearResData();
}

///
/// \brief ResponseServer::resUnimplemented
///
void ResponseServer::resUnimplemented(void) {
    this->clearResData();
}

///
/// \brief ResponseServer::resolve
///
void ResponseServer::resolve(void) {
    const int BUFLEN = 5000;
    char recvBuf[BUFLEN];
    int nRC;

    while (true) {

        nRC = recv(this->sock, recvBuf, BUFLEN, 0);
        if (nRC == SOCKET_ERROR) {
            // 接受数据错误，
            // 记录下产生错误的会话SOCKET
            closesocket(this->sock);
            emit finished();
            return ;
        } else {
            if (nRC > 0) {
                // 接收数据成功，保存在发送缓冲区中，
                // 以发送到所有客户去
                recvBuf[nRC - 1] = '\0';
                emit rcvReq(QString(recvBuf));

                this->clearResData();

                // response header
                this->setResVersion("1.1");
                this->setResStatus("200");
                this->appendResField("Connection", "keep-alive");
                this->appendResField("Server", "Dragon Web Server");
                this->appendResField("Content-Type", "text/html");

                // response body
                ifstream responseHTML("./index.html", ios::in);
                if (!responseHTML.is_open()) {
                    this->resNotFound();
                    continue;
                }

                ostringstream oss;
                oss << responseHTML.rdbuf();
                this->resBody = oss.str();

                //                sprintf(sendBuf, "HTTP/1.1 200 OK\nConnection: keep-alive\nServer: Dragon Web Server\nContent-Type: text/html\n\n \
                //                        <!DOCTYPE html>\n\
                //                        <html lang = \"en\">\n\
                //                                <head>\n\
                //                                <meta charset = \"utf-8\">\n\
                //                                </head>\n\
                //                                <body>\n\
                //                                <h1>Hello, Dragon Web Server!</h1>\n\
                //                        </body> \
                //                        </html>");

                string resData = this->getResData();
                nRC = send(this->sock, resData.c_str(), resData.length(), 0);
                if (nRC == SOCKET_ERROR) {
                    // 发送数据错误，
                    // 记录下产生错误的会话SOCKET
                        closesocket(this->sock);
                        emit finished();
                        return ;
                } else {
                    // 发送数据成功，清空发送缓冲区
                    emit sndRes(QString(resData.c_str()));
                    this->clearResData();
                }

            } else {
                // @TODO: 设定一个定时器
                // time out
                // 再无数据接收, 关闭连接
                closesocket(this->sock);
                emit finished();
                return ;
            }
        }
    }

}
