#include "cpuwindow.h"
#include "ui_cpuwindow.h"

cpuWindow::cpuWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::cpuWindow)
{
    ui->setupUi(this);
}

cpuWindow::~cpuWindow()
{
    delete ui;
}
