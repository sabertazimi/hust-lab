#ifndef RESPONSESERVER_H
#define RESPONSESERVER_H

#include <QObject>
#include <QString>
#include <vector>
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
    explicit ResponseServer(SOCKET sock, string path, QObject *parent = 0);
    ~ResponseServer(void);

signals:
    ///
    /// \brief rcvReq
    ///
    void rsRcvReq(const QString &);
    ///
    /// \brief sndRes
    ///
    void rsSndRes(const QString &);
    ///
    /// \brief finished
    ///
    void finished();

public slots:
    void resolve(void);

private:
    SOCKET sock;
    string filePath;

    string reqVersion;
    string reqMethod;
    string reqURL;
    string reqIP;
    string reqFileType;

    string resVersion;
    string resStatus;
    vector<string> resHeaderFields;
    string resBody;

private:
    vector<string> split(const string &s, char delim);
    void parseRequest(string req);

    string getReqData(void);
    void setResVersion(string version);
    void setResStatus(string statusCode);
    bool setResBody(string url);
    void appendResField(string key, string value);
    void clearResHeader(void);
    string getResData(void);

    void resSuccess(void);
    void resBadRequest(void);
    void resNotFound(void);
    void resUnimplemented(void);
};

#endif // RESPONSESERVER_H
