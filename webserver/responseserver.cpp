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

string ResponseServer::normalize(string path) {
    string normalizedPath = path;

    replace(normalizedPath.begin(), normalizedPath.end(), '/', '\\');

    if (normalizedPath[normalizedPath.length() - 1] == '\\') {
        normalizedPath += "index.html";
    }

    return normalizedPath;
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

    this->reqMethod = firstLine[0];
    this->reqVersion = firstLine[2];
    this->reqIP = hostLine;

    // parse file type and url
    string normalizedURL = firstLine[1];
    normalizedURL = this->normalize(normalizedURL);
    this->reqURL = normalizedURL;

    vector<string> fileType = this->split(normalizedURL, '.');
    if (fileType.size() > 0) {
        this->reqFileType = fileType[fileType.size() - 1];
    } else {
        this->reqFileType = "html";
    }
    this->reqFileType = fileType[fileType.size() <= 0 ? 0 : (fileType.size() - 1)];
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
    string contentType = this->getContentType();
    ifstream *responseData;

    if (contentType.find("text") == string::npos && contentType.find("javascript") == string::npos) {
        responseData = new ifstream(fullPath, ios::binary);
    } else {
        responseData = new ifstream(fullPath, ios::in);
    }

    if (!responseData->is_open()) {
        return false;
    }

    ostringstream oss;
    oss << responseData->rdbuf();
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

string ResponseServer::getContentType(void) {
    string contentType;

    if (this->reqFileType == "html" || this->reqFileType == "htx") {
        contentType = "text/html";
    } else if (this->reqFileType == "css") {
        contentType = "text/css";
    } else if (this->reqFileType == "js") {
        contentType = "application/x-javascript";
    } else if (this->reqFileType == "ico") {
        contentType = "image/x-icon";
    } else if (this->reqFileType == "jpg" || this->reqFileType == "jpeg"
               || this->reqFileType == "gif" || this->reqFileType == "tiff") {
        contentType = "image";
    } else if (this->reqFileType == "mp4") {
        contentType = "video/mp4";
    } else if (this->reqFileType == "mp3") {
        contentType = "audio/mp3";
    } else {
        contentType = "text/plain";
    }

    return contentType;
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
    this->appendResField("Content-Type", this->getContentType());

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
    this->setResStatus(resStatus);
    this->appendResField("Connection", "keep-alive");
    this->appendResField("Server", "Dragon Web Server");
    this->appendResField("Content-Type", "text/html");

    this->resBody = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\"></head><body style=\"background-color: #228ae6\"><div class=\"error\" style=\"color: white; margin-top: 30vh; text-align: center\"><h1>" + resStatus + "</h1></div><br /><br /><div class=\"info\" style=\"color: white; text-align: center\">" + resBody + "</div></body></html>";

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
