#include "sumwindow.h"
#include "ui_sumwindow.h"

sumWindow::sumWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::sumWindow)
{
    ui->setupUi(this);
}

sumWindow::~sumWindow()
{
    delete ui;
}
