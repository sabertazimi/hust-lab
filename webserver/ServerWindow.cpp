#include <QMainWindow>
#include <QMessageBox>
#include <QString>
#include <QTimer>
#include <QLabel>
#include <QDesktopWidget>
#include "serverwindow.h"

using namespace std;

///
/// \brief ServerWindow::ServerWindow
/// \param parent
///
ServerWindow::ServerWindow(QWidget *parent) : QMainWindow(parent) {
    QDesktopWidget dw;
    this->setFixedSize(dw.width(), dw.height());

    label = new QLabel(this);
    label->setText("Welcome to Dragon Web Server");
    label->setFixedSize(220,50);

    // using slots to implement update
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateServer()));
    timer->start(2000);
    // QMessageBox::critical(this, "Error", "Restart to fix unkown error!");
}

///
/// \brief ServerWindow::~ServerWindow
///
ServerWindow::~ServerWindow(void) {
    delete label;
    delete timer;
}

///
/// \brief ServerWindow::getServer
/// \return
///
QString ServerWindow::getServer(void) {
    return QString("Web Server");
}

///
/// \brief ServerWindow::updateServer
///
void ServerWindow::updateServer(void) {
    label->setText(getServer());
}
