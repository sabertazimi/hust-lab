#ifndef DRAGONWEBSERVER_H
#define DRAGONWEBSERVER_H

#include <QObject>
#include <QString>
#include <winsock2.h>
#include <list>

#define MAXCONN 5
#define SERVER_PORT 80

class ServerWindow;

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
    explicit DragonWebServer(ServerWindow *ui, QObject *parent = 0);
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

signals:
    ///
    /// \brief finished
    ///
    void finished();

public slots:
    ///
    /// \brief runServer
    /// \param dwsopt
    /// \return
    ///
    int runServer(void);
    void stopServer(void);

private:
    ServerWindow *ui;
    ///
    /// \brief srvSock
    ///
    SOCKET srvSock;
    ///
    /// \brief dwsopt
    ///
    dwsOptions dwsopt;
};

#endif // DRAGONWEBSERVER_H
