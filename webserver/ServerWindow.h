#ifndef SERVERWINDOW_H
#define SERVERWINDOW_H

#include <QMainWindow>
#include <QString>
#include <QTimer>
#include <QLabel>
#include <list>

///
/// \brief The ServerWindow class
///
class ServerWindow : public QMainWindow
{
    Q_OBJECT

public:
    ///
    /// \brief ServerWindow
    /// \param parent
    ///
    explicit ServerWindow(QWidget *parent = 0);
    ~ServerWindow(void);

public slots:
    void logReq(QString req);

private:
    ///
    /// \brief label
    ///
    QLabel *label;
    ///
    /// \brief timer
    ///
    QTimer *timer;
    ///
    /// \brief reqlogs
    ///
    std::list <QString> reqlogs;
    ///
    /// \brief getServer
    /// \return
    ///
    QString getServer(void);
    ///
    /// \brief setText
    /// \param txt
    /// \return
    ///
    QMainWindow &setText(QString msg);

private slots:
    ///
    /// \brief updateServer
    ///
    void updateServer(void);
};

#endif // SERVERWINDOW_H
