#ifndef SERVERWINDOW_H
#define SERVERWINDOW_H

#include <QMainWindow>
#include <QString>
#include <QTimer>
#include <QLabel>

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
    /// \brief getServer
    /// \return
    ///
    QString getServer(void);
    ///
    /// \brief setText
    /// \param txt
    /// \return
    ///
    QMainWindow &setText(const char *txt);

private slots:
    ///
    /// \brief updateServer
    ///
    void updateServer(void);
};

#endif // SERVERWINDOW_H
