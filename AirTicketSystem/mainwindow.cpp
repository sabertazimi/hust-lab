#include <QWidget>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QLabel>
#include <QPushButton>
#include <QDesktopWidget>
#include <QIcon>
#include <QPixmap>
#include <QTabWidget>
#include <QString>
#include <QRegExp>
#include <QRegExpValidator>
#include <QMessageBox>
#include <QTableWidget>
#include <QDebug>
#include "visitor.h"
#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent) {
    // resize default window size
    QDesktopWidget dw;
    this->resize(dw.width(), dw.height());
    this->visitor = nullptr;

    this->createLoginView();
}

MainWindow::~MainWindow() {
}

void MainWindow::createLoginView(void) {
    this->loginMainWindow = new QWidget();

    this->loginIDEdit = new QLineEdit(this->loginMainWindow);
    this->loginNameEdit = new QLineEdit(this->loginMainWindow);
    this->loginPasswordEdit = new QLineEdit(this->loginMainWindow);
    this->loginIDLabel = new QLabel(QWidget::tr("&ID"), this->loginMainWindow);
    this->loginNameLabel = new QLabel(QWidget::tr("&Name"), this->loginMainWindow);
    this->loginPasswordLabel = new QLabel(QWidget::tr("&Password"), this->loginMainWindow);
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
    connect(this->loginVisitorButton, SIGNAL(released()), this, SLOT(onLoginVisitorButton()));
    connect(this->loginAdminButton, SIGNAL(released()), this, SLOT(onLoginAdminButton()));
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
    this->loginMainLayout->addStretch();
    this->loginMainLayout->addLayout(this->loginBottomLayout);
    this->loginMainLayout->addStretch();
    this->loginMainLayout->addStretch();
    this->loginMainWindow->setLayout(this->loginMainLayout);

    this->setCentralWidget(this->loginMainWindow);
}

MainWindow *MainWindow::createAdminView(void) {
    return this;
}

MainWindow *MainWindow::createVisitorView(void) {
    this->visitorTab = new QTabWidget();
    this->createVisPurchaseWindow();

    this->visitorTab->addTab(this->visPurchaseWindow, QIcon(":/at/assets/ticket_purchase.svg"), "Purchase Ticket");
    this->visitorTab->addTab(new QTabWidget(), QIcon(":/at/assets/ticket_remind.svg"), "Fetch Ticket");
    this->visitorTab->addTab(new QTabWidget(), QIcon(":/at/assets/ticket_cancel.svg"), "Cancel Ticket");
    this->visitorTab->addTab(new QTabWidget(), QIcon(":/at/assets/ticket_billing.svg"), "Billing");
    this->visitorTab->addTab(new QTabWidget(), QIcon(":/at/assets/ticket_data.svg"), "Query");
    this->setCentralWidget(this->visitorTab);
    return this;
}

MainWindow *MainWindow::createVisPurchaseWindow(void) {
    this->visPurchaseWindow = new QWidget();

    this->visPurchaseStartEdit = new QLineEdit(this->visPurchaseWindow);
    this->visPurchaseEndEdit = new QLineEdit(this->visPurchaseWindow);
    this->visPurchaseStartLabel = new QLabel(QWidget::tr("&Start"), this->visPurchaseWindow);
    this->visPurchaseEndLabel = new QLabel(QWidget::tr("&End"), this->visPurchaseWindow);
    this->visPurchaseStartLabel->setBuddy(this->visPurchaseStartEdit);
    this->visPurchaseEndLabel->setBuddy(this->visPurchaseEndEdit);
    this->visPurchaseButton = new QPushButton(QWidget::tr("Purchase"), this->visPurchaseWindow);
    connect(this->visPurchaseButton, SIGNAL(released()), this, SLOT(onVisPurchaseButton()));
    this->visPurchaseTopLayout = new QHBoxLayout();
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addWidget(this->visPurchaseStartLabel);
    this->visPurchaseTopLayout->addWidget(this->visPurchaseStartEdit);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addWidget(this->visPurchaseEndLabel);
    this->visPurchaseTopLayout->addWidget(this->visPurchaseEndEdit);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addWidget(this->visPurchaseButton);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addStretch();

    this->visPurchaseBottomLayout = new QHBoxLayout();
    this->visPurchaseTable = new QTableWidget(2, 5);
    this->visPurchaseTable->setWindowTitle("Flight");
    this->visPurchaseTable->resize(this->visPurchaseTable->maximumWidth(), this->visPurchaseTable->maximumHeight());
    this->visPurchaseTable->setItem(0, 0, new QTableWidgetItem("Welcome to Air Ticket System"));
    this->visPurchaseTable->setItem(1, 0, new QTableWidgetItem("Welcome to Air Ticket System"));
    this->visPurchaseTable->setAlternatingRowColors(true);
    // @TODO 1: disable editor
    // @TODO 2: change alternate font color to white
    this->visPurchaseTable->setStyleSheet("alternate-color: white; alternate-background-color: #00695c;");
    // this->visPurchaseTable->resizeColumnsToContents();
    this->visPurchaseTable->resizeRowsToContents();
    this->visPurchaseBottomLayout->addWidget(this->visPurchaseTable);

    this->visPurchaseMainLayout = new QVBoxLayout();
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseMainLayout->addLayout(this->visPurchaseTopLayout);
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseMainLayout->addLayout(this->visPurchaseBottomLayout);
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseWindow->setLayout(this->visPurchaseMainLayout);

    return this;
}

MainWindow *MainWindow::createVisFetchWindow(void) {
    return this;
}

MainWindow *MainWindow::createVisCancelWindow(void) {
    return this;
}

MainWindow *MainWindow::createVisBillingWindow(void) {
    return this;
}

MainWindow *MainWindow::createVisQueryWindow(void) {
    return this;
}

void MainWindow::onLoginAdminButton(void) {

}

void MainWindow::onLoginVisitorButton(void) {
    QString id = this->loginIDEdit->text();
    QString name = this->loginNameEdit->text();
    QRegExpValidator idRegExp(QRegExp("[0-9]{14}[0-9X]{4}"));
    QRegExpValidator nameRegExp(QRegExp("[A-Za-z0-9_]{6,30}"));

    if (id == "") {
    // @TODO
    // if (id == "" || !idRegExp.regExp().exactMatch(id)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Error ID Format: must be 18 digits (can including 'X' in last 4 digits)!");
        return ;
    }

    if (name == "") {
    // @TODO
    // if (name == "" || !nameRegExp.regExp().exactMatch(name)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Error Name Format: must be only including alphabet, digital number and underline (6 ~ 30 characters)!");
        return ;
    }

    if (this->visitor != nullptr) {
        delete this->visitor;
        this->visitor = nullptr;
    }

    this->visitor = new Visitor(id, name);

    if (this->visitor->state == Visitor::VISITOR) {
        showMsgBox(":/at/assets/right.png", "Success",
            "Welcome to Air Ticket System");
        this->createVisitorView();
        this->setCentralWidget(this->visitorTab);
    } else {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Error: database connenction failure!");
    }
}

void MainWindow::onVisPurchaseButton(void) {
    // this->createLoginView();
    // this->setCentralWidget(this->loginMainWindow);
}
