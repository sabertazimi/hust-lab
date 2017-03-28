#ifndef DRAGONWEBSERVER_H
#define DRAGONWEBSERVER_H

#include <QObject>
#include <QString>
#include <winsock2.h>
#include <list>

#define MAXCONN 5
#define BUFLEN 5000
#define SERVER_PORT 80

///
/// \brief ListCONN
///
typedef std::list<SOCKET> ListCONN;

///
/// \brief ListConErr
///
typedef std::list<SOCKET> ListConErr;

typedef struct dwsOptions {
    QString ip;
    int port;
    QString filePath;
} dwsOptions;

///
/// \brief The DragonWebServer class
///
class DragonWebServer : public QObject {
    Q_OBJECT
public:
    ///
    /// \brief DragonWebServer
    /// \param parent
    ///
    explicit DragonWebServer(QObject *parent = 0);
    ~DragonWebServer(void);
    ///
    /// \brief setOptions
    /// \param dwsopt
    /// \return
    ///
    DragonWebServer &setOptions(dwsOptions dwsopt);
    ///
    /// \brief setIP
    /// \param ip
    /// \return
    ///
    DragonWebServer &setIP(QString ip);
    ///
    /// \brief setPort
    /// \param port
    /// \return
    ///
    DragonWebServer &setPort(int port);
    ///
    /// \brief setPath
    /// \param filePath
    /// \return
    ///
    DragonWebServer &setPath(QString filePath);

public slots:
    ///
    /// \brief runServer
    /// \param dwsopt
    /// \return
    ///
    int runServer(void);

signals:
    ///
    /// \brief rcvReq
    ///
    void rcvReq(QString);
    ///
    /// \brief sndRes
    ///
    void sndRes(QString);
    ///
    /// \brief finished
    ///
    void finished();

private:
    ///
    /// \brief dwsopt
    ///
    dwsOptions dwsopt;
};

#endif // DRAGONWEBSERVER_H
