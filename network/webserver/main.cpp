#include <QApplication>
#include "serverwindow.h"

///
/// \brief qMain
/// \param argc
/// \param argv
/// \return
///
int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    ServerWindow serverWindow;
    serverWindow.show();

    return app.exec();
}
