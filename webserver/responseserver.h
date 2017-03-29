#ifndef RESPONSESERVER_H
#define RESPONSESERVER_H

#include <QObject>
#include <winsock2.h>
#include <string>

using namespace std;

#define RES_BAD_REQUEST 			400
#define RES_NOT_FOUND   			404
#define RES_METHOD_NOT_IMPLEMENTED  501

class ResponseServer : public QObject
{
    Q_OBJECT
public:
    explicit ResponseServer(SOCKET sock, QObject *parent = 0);
    ~ResponseServer(void);

signals:

public slots:
    void resolve(void);

private:
    SOCKET sock;
    list<string> resHeaders;
    string resBody;

private:
    list<string> split(const string &s, char delim);
    string parseURL(string url);
    void appendField(string key, string value);
    void clearResponse(void);
    void resBadRequest(void);
    void resNotFound(void);
    void resUnimplemented(void);
};

#endif // RESPONSESERVER_H
