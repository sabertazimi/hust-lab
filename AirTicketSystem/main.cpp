#include <QApplication>
#include <QFile>
#include <QTextStream>
#include "mainwindow.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    // load qt style sheet
    QFile file(":material/material.qss");
    if (!file.exists()) {
        printf("Unable to set stylesheet, file not found\n");
    } else {
        file.open(QFile::ReadOnly | QFile::Text);
        QTextStream ts(&file);
        app.setStyleSheet(ts.readAll());
    }

    MainWindow w;
    w.show();

    return app.exec();
}
