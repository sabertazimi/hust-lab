#include <QWidget>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QLabel>
#include <QPushButton>
#include <QDesktopWidget>
#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent) {
    // resize default window size
    QDesktopWidget dw;
    this->resize(dw.width(), dw.height());

    this->createLoginView();
}

MainWindow::~MainWindow() {

}

MainWindow &MainWindow::createLoginView(void) {
    this->loginMainWindow = new QWidget();

    this->loginIDEdit = new QLineEdit(this->loginMainWindow);
    this->loginNameEdit = new QLineEdit(this->loginMainWindow);
    this->loginPasswordEdit = new QLineEdit(this->loginMainWindow);
    this->loginIDLabel = new QLabel(QWidget::tr("&ID:"), this->loginMainWindow);
    this->loginNameLabel = new QLabel(QWidget::tr("&Name:"), this->loginMainWindow);
    this->loginPasswordLabel = new QLabel(QWidget::tr("&Password:"), this->loginMainWindow);
    this->loginIDLabel->setBuddy(this->loginIDEdit);
    this->loginNameLabel->setBuddy(this->loginNameEdit);
    this->loginPasswordLabel->setBuddy(this->loginPasswordEdit);
    this->loginTopLayout = new QGridLayout();
    this->loginTopLayout->addWidget(this->loginIDLabel, 0, 0);
    this->loginTopLayout->addWidget(this->loginIDEdit, 0, 1);
    this->loginTopLayout->addWidget(this->loginNameLabel, 1, 0);
    this->loginTopLayout->addWidget(this->loginNameEdit, 1, 1);
    this->loginTopLayout->addWidget(this->loginPasswordLabel, 2, 0);
    this->loginTopLayout->addWidget(this->loginPasswordEdit, 2, 1);

    this->loginVisitorButton = new QPushButton(QWidget::tr("Login as Visitor"), this->loginMainWindow);
    this->loginAdminButton = new QPushButton(QWidget::tr("Login as Administrator"), this->loginMainWindow);
    this->loginBottomLayout = new QHBoxLayout();
    this->loginBottomLayout->addStretch();
    this->loginBottomLayout->addStretch();
    this->loginBottomLayout->addStretch();
    this->loginBottomLayout->addWidget(this->loginVisitorButton);
    this->loginBottomLayout->addStretch();
    this->loginBottomLayout->addWidget(this->loginAdminButton);
    this->loginBottomLayout->addStretch();
    this->loginBottomLayout->addStretch();
    this->loginBottomLayout->addStretch();

    this->loginMainLayout = new QVBoxLayout();
    this->loginMainLayout->addStretch();
    this->loginMainLayout->addLayout(this->loginTopLayout);
    this->loginMainLayout->addLayout(this->loginBottomLayout);
    this->loginMainLayout->addStretch();
    this->loginMainLayout->addStretch();

    this->loginMainWindow->setLayout(this->loginMainLayout);
    this->setCentralWidget(this->loginMainWindow);

    return *this;
}
