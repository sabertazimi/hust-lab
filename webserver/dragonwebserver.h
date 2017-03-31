#ifndef DRAGONWEBSERVER_H
#define DRAGONWEBSERVER_H

#include <QObject>
#include <string>
#include <winsock2.h>
#include <list>

using namespace std;

#define MAXCONN 5

class ServerWindow;

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
    DragonWebServer &setConfigFromUI(void);
    ///
    /// \brief setIP
    /// \param ip
    /// \return
    ///
    DragonWebServer &setIP(string ip);
    ///
    /// \brief setPort
    /// \param port
    /// \return
    ///
    DragonWebServer &setPort(string port);
    ///
    /// \brief setPath
    /// \param filePath
    /// \return
    ///
    DragonWebServer &setPath(string filePath);

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
    string ip;
    int port;
    string filePath;
};

#endif // DRAGONWEBSERVER_H
