#include <winsock2.h>
#include <sstream>
#include <string>
#include <list>
#include "responseserver.h"

using namespace std;

ResponseServer::ResponseServer(SOCKET sock, QObject *parent) : QObject(parent)
{
    this->sock = sock;
    this->resHeaders.clear();
}

list<string> ResponseServer::split(const std::string &s, char delim) {
        list<string> elems;
        stringstream ss;
        ss.str(s);
        string item;

        while (getline(ss, item, delim)) {
            elems.insert(elems.end(), item);
        }

        return elems;
}

string ResponseServer::parseURL(string url) {
    list<string> splitURL = this->split(url, '/');
    return splitURL[splitURL.size()-1];
}

ResponseServer::~ResponseServer(void) {
}

void ResponseServer::clearResponse(void) {
    this->resHeaders.clear();
    this->resBody = "";
}


void ResponseServer::resBadRequest(void) {
    this->clearResponse();
}

void ResponseServer::resNotFound(void) {
    this->clearResponse();
}

void ResponseServer::resUnimplemented(void) {
    this->clearResponse();

}

void ResponseServer::appendField(string key, string value) {
    this->resHeaders.insert(resHeaders.end(), key + string(": ") + value);
}
