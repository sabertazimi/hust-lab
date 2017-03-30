#include <QString>
#include <winsock2.h>
#include <sstream>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include "responseserver.h"

using namespace std;

///
/// \brief ResponseServer::ResponseServer
/// \param sock
/// \param parent
///
ResponseServer::ResponseServer(SOCKET sock, string path, QObject *parent) : QObject(parent) {
    this->sock = sock;
    this->filePath = path;
    this->clearResHeader();
    this->resBody = "";
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
void ResponseServer::parseRequest(string req) {
    vector<string> lines = this->split(req, '\n');
    vector<string> firstLine = this->split(lines[0], ' ');
    string hostLine = lines[1];
    string normalizedURL = firstLine[1];
    replace(normalizedURL.begin(), normalizedURL.end(), '/', '\\');

    this->reqMethod = firstLine[0];
    this->reqURL = (normalizedURL == "\\") ? "\\index.html" : normalizedURL;
    this->reqVersion = firstLine[2];
    this->reqIP = hostLine;
}

void ResponseServer::setResVersion(string version) {
    this->resVersion = version;
}

void ResponseServer::setResStatus(string statusCode) {
    if (statusCode == "200") {
        this->resStatus = "200 OK";
    } else if (statusCode == "404") {
        this->resStatus = "404 Not Found";
    } else if (statusCode == "501") {
        this->resStatus = "501 Not Implemented";
    } else {
        this->resStatus = "400 Bad Request";
    }
}

bool ResponseServer::setResBody(string url) {
    string fullPath = this->filePath + url;
    ifstream responseHTML(fullPath, ios::in);

    if (!responseHTML.is_open()) {
        return false;
    }

    ostringstream oss;
    oss << responseHTML.rdbuf();
    this->resBody = oss.str();
    return true;
}

void ResponseServer::appendResField(string key, string value) {
    (this->resHeaderFields).push_back(key + string(": ") + value);
}

void ResponseServer::clearResHeader(void) {
    this->resVersion = "";
    this->resStatus = "";
    this->resHeaderFields.clear();
}

string ResponseServer::getResData(void) {
    string resData = this->resVersion + " " + this->resStatus + "\n";

    for (int i = 0, size = (this->resHeaderFields).size(); i < size; i++) {
        resData += ((this->resHeaderFields)[i] + "\n");
    }

    resData += "\n" + this->resBody;

    return resData;
}

void ResponseServer::resSuccess(void) {
    int nRC;

    this->clearResHeader();

    // response header
    this->setResVersion(this->reqVersion);
    this->setResStatus("200");
    this->appendResField("Connection", "keep-alive");
    this->appendResField("Server", "Dragon Web Server");

    // @TODO: multiple-type files
    this->appendResField("Content-Type", "text/html");

    string resData = this->getResData();

    nRC = send(this->sock, resData.c_str(), resData.length(), 0);
    if (nRC != SOCKET_ERROR) {
        // 发送数据成功，清空发送缓冲区
        emit rsSndRes(QString(resData.c_str()));
        this->clearResHeader();
        this->resBody = "";
    }

    // @TODO timer
    closesocket(this->sock);
    emit finished();
}

void ResponseServer::resFail(string resStatus, string resBody) {
    int nRC;

    this->clearResHeader();
    this->resBody = "";

    // response header
    this->setResVersion(this->reqVersion);
    this->setResStatus("resStatus");
    this->appendResField("Connection", "keep-alive");
    this->appendResField("Server", "Dragon Web Server");

    // @TODO: multiple-type files
    this->appendResField("Content-Type", "text/html");

    this->resBody = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\"></head><body><h1>" + resBody + "</h1></body></html>";

    string resData = this->getResData();

    nRC = send(this->sock, resData.c_str(), resData.length(), 0);
    if (nRC != SOCKET_ERROR) {
        // 发送数据成功，清空发送缓冲区
        emit rsSndRes(QString(resData.c_str()));
        this->clearResHeader();
        this->resBody = "";
    }

    // @TODO timer
    closesocket(this->sock);
    emit finished();
}

///
/// \brief ResponseServer::resBadRequest
///
void ResponseServer::resBadRequest(void) {
    this->resFail("400", "Bad Request");
}

///
/// \brief ResponseServer::resNotFound
///
void ResponseServer::resNotFound(void) {
    this->resFail("404", "Not Found");
}

///
/// \brief ResponseServer::resUnimplemented
///
void ResponseServer::resUnimplemented(void) {
    this->resFail("501", "Method Not Implemented");
}

string ResponseServer::getReqData(void) {
    string reqData;
    reqData = this->reqMethod + " " + this->reqURL + " " + this->reqVersion;
    reqData = reqData + "\n" + this->reqIP;
    return reqData;
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
                recvBuf[nRC - 1] = '\0';
                this->parseRequest(string(recvBuf));
                emit rsRcvReq(QString(this->getReqData().c_str()));

                if (this->reqMethod != "GET") {
                    this->resUnimplemented();
                    continue;
                }

                bool success = this->setResBody(this->reqURL);

                if (!success) {
                    this->resNotFound();
                } else {
                    this->resSuccess();
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
