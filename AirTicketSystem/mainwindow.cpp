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
#include <QDateTime>
#include <QDateTimeEdit>
#include <QComboBox>
#include <QSqlQuery>
#include <QDebug>
#include "visitor.h"
#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent) {
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
    this->loginPasswordEdit->setEchoMode(QLineEdit::Password);
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
    this->adminTab = new QTabWidget();
    this->createAdminFlightWindow();
    this->createAdminSeatWindow();

    this->adminTab->addTab(this->adminFlightWindow, QIcon(":/at/assets/ticket_purchase.svg"), "Flight");
    this->adminTab->addTab(this->adminSeatWindow, QIcon(":/at/assets/ticket_data.svg"), "Seat");
    return this;
}

MainWindow *MainWindow::createAdminFlightWindow(void) {
    this->adminFlightWindow = new QWidget();

    this->adminFlightNoEdit = new QLineEdit(this->adminFlightWindow);
    this->adminFlightStartEdit = new QLineEdit(this->adminFlightWindow);
    this->adminFlightEndEdit = new QLineEdit(this->adminFlightWindow);
    this->adminFlightTimeEdit = new QDateTimeEdit(QDateTime::currentDateTime(), this->adminFlightWindow);
    this->adminFlightNoLabel = new QLabel(QWidget::tr("&No"), this->adminFlightWindow);
    this->adminFlightStartLabel = new QLabel(QWidget::tr("&Start"), this->adminFlightWindow);
    this->adminFlightEndLabel = new QLabel(QWidget::tr("&End"), this->adminFlightWindow);
    this->adminFlightTimeLabel = new QLabel(QWidget::tr("&Time"), this->adminFlightWindow);
    this->adminFlightNoLabel->setBuddy(this->adminFlightNoEdit);
    this->adminFlightStartLabel->setBuddy(this->adminFlightStartEdit);
    this->adminFlightEndLabel->setBuddy(this->adminFlightEndEdit);
    this->adminFlightTimeLabel->setBuddy(this->adminFlightTimeEdit);
    this->adminFlightAddButton = new QPushButton(QWidget::tr("Add"), this->adminFlightWindow);
    this->adminFlightDelButton = new QPushButton(QWidget::tr("Delete"), this->adminFlightWindow);
    connect(this->adminFlightAddButton, SIGNAL(released()), this, SLOT(onAdminFlightAddButton()));
    connect(this->adminFlightDelButton, SIGNAL(released()), this, SLOT(onAdminFlightDelButton()));
    this->adminFlightTopLayout = new QHBoxLayout();
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addWidget(this->adminFlightNoLabel);
    this->adminFlightTopLayout->addWidget(this->adminFlightNoEdit);
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addWidget(this->adminFlightStartLabel);
    this->adminFlightTopLayout->addWidget(this->adminFlightStartEdit);
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addWidget(this->adminFlightEndLabel);
    this->adminFlightTopLayout->addWidget(this->adminFlightEndEdit);
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addWidget(this->adminFlightTimeLabel);
    this->adminFlightTopLayout->addWidget(this->adminFlightTimeEdit);
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addWidget(this->adminFlightAddButton);
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addWidget(this->adminFlightDelButton);
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addStretch();
    this->adminFlightTopLayout->addStretch();

    this->adminFlightBottomLayout = new QHBoxLayout();
    this->adminFlightTable = new QTableWidget(0, 4);
    this->adminFlightTable->setWindowTitle("Flight");
    this->adminFlightTable->resize(this->adminFlightTable->maximumWidth(), this->adminFlightTable->maximumHeight());
    this->adminFlightTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->adminFlightTable->setAlternatingRowColors(true);
    this->adminFlightTable->setStyleSheet("alternate-background-color: #aaa;");
    this->adminFlightTable->resizeRowsToContents();
    this->adminRenderFlightTable();
    this->adminFlightBottomLayout->addStretch();
    this->adminFlightBottomLayout->addWidget(this->adminFlightTable);
    this->adminFlightBottomLayout->addStretch();

    this->adminFlightMainLayout = new QVBoxLayout();
    this->adminFlightMainLayout->addStretch();
    this->adminFlightMainLayout->addLayout(this->adminFlightTopLayout);
    this->adminFlightMainLayout->addStretch();
    this->adminFlightMainLayout->addLayout(this->adminFlightBottomLayout);
    this->adminFlightMainLayout->addStretch();
    this->adminFlightMainLayout->addStretch();
    this->adminFlightWindow->setLayout(this->adminFlightMainLayout);

    return this;
}

void MainWindow::adminRenderFlightTable(void) {
    int cnt = this->adminFlightTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->adminFlightTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.exec("SELECT * FROM [Flight]");

    while (query.next()) {
        cnt = this->adminFlightTable->rowCount();
        QString no = query.value(0).toString();
        QString start = query.value(1).toString();
        QString end = query.value(2).toString();
        QDateTime time = query.value(3).toDateTime();
        this->adminFlightTable->insertRow(cnt);
        this->adminFlightTable->setItem(cnt, 0, new QTableWidgetItem(no));
        this->adminFlightTable->setItem(cnt, 1, new QTableWidgetItem(start));
        this->adminFlightTable->setItem(cnt, 2, new QTableWidgetItem(end));
        this->adminFlightTable->setItem(cnt, 3, new QTableWidgetItem(time.toString()));
    }

    this->adminFlightTable->resizeColumnsToContents();
    this->adminFlightTable->resizeRowsToContents();
}

void MainWindow::onAdminFlightAddButton(void) {
    QString no = this->adminFlightNoEdit->text();
    QString start = this->adminFlightStartEdit->text();
    QString end = this->adminFlightEndEdit->text();
    QDateTime time = this->adminFlightTimeEdit->dateTime();

    if (no == "" || start == "" || end == "" || !this->visitor->addFlight(no, start, end, time)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Add Flight Failure!");
    }

    this->adminRenderFlightTable();
}

void MainWindow::onAdminFlightDelButton(void) {
    QString no = this->adminFlightNoEdit->text();

    if (no == "" || !this->visitor->delFlight(no)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Delete Flight Failure!");
    }

    this->adminRenderFlightTable();
}

MainWindow *MainWindow::createAdminSeatWindow(void) {
    this->adminSeatWindow = new QWidget();

    this->adminSeatFnoEdit = new QLineEdit(this->adminSeatWindow);
    this->adminSeatSnoEdit = new QLineEdit(this->adminSeatWindow);
    this->adminSeatTypeEdit = new QComboBox(this->adminSeatWindow);
    this->adminSeatTypeEdit->setEditable(true);
    this->adminSeatTypeEdit->insertItem(0, "一等座");
    this->adminSeatTypeEdit->insertItem(1, "二等座");
    this->adminSeatTypeEdit->insertItem(2, "三等座");
    this->adminSeatPriceEdit = new QLineEdit(this->adminSeatWindow);
    this->adminSeatFnoLabel = new QLabel(QWidget::tr("&Flight No"), this->adminSeatWindow);
    this->adminSeatSnoLabel = new QLabel(QWidget::tr("&Seat No"), this->adminSeatWindow);
    this->adminSeatTypeLabel = new QLabel(QWidget::tr("&Type"), this->adminSeatWindow);
    this->adminSeatPriceLabel = new QLabel(QWidget::tr("&Price"), this->adminSeatWindow);
    this->adminSeatFnoLabel->setBuddy(this->adminSeatFnoEdit);
    this->adminSeatSnoLabel->setBuddy(this->adminSeatSnoEdit);
    this->adminSeatTypeLabel->setBuddy(this->adminSeatTypeEdit);
    this->adminSeatPriceLabel->setBuddy(this->adminSeatPriceEdit);
    this->adminSeatAddButton = new QPushButton(QWidget::tr("Add"), this->adminSeatWindow);
    this->adminSeatDelButton = new QPushButton(QWidget::tr("Delete"), this->adminSeatWindow);
    connect(this->adminSeatAddButton, SIGNAL(released()), this, SLOT(onAdminSeatAddButton()));
    connect(this->adminSeatDelButton, SIGNAL(released()), this, SLOT(onAdminSeatDelButton()));
    this->adminSeatTopLayout = new QHBoxLayout();
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addWidget(this->adminSeatFnoLabel);
    this->adminSeatTopLayout->addWidget(this->adminSeatFnoEdit);
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addWidget(this->adminSeatSnoLabel);
    this->adminSeatTopLayout->addWidget(this->adminSeatSnoEdit);
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addWidget(this->adminSeatTypeLabel);
    this->adminSeatTopLayout->addWidget(this->adminSeatTypeEdit);
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addWidget(this->adminSeatPriceLabel);
    this->adminSeatTopLayout->addWidget(this->adminSeatPriceEdit);
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addWidget(this->adminSeatAddButton);
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addWidget(this->adminSeatDelButton);
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addStretch();
    this->adminSeatTopLayout->addStretch();

    this->adminSeatBottomLayout = new QHBoxLayout();
    this->adminSeatTable = new QTableWidget(0, 4);
    this->adminSeatTable->setWindowTitle("Seat");
    this->adminSeatTable->resize(this->adminSeatTable->maximumWidth(), this->adminSeatTable->maximumHeight());
    this->adminFlightTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->adminSeatTable->setAlternatingRowColors(true);
    this->adminSeatTable->setStyleSheet("alternate-background-color: #aaa;");
    this->adminSeatTable->resizeRowsToContents();
    this->adminRenderSeatTable();
    this->adminSeatBottomLayout->addStretch();
    this->adminSeatBottomLayout->addWidget(this->adminSeatTable);
    this->adminSeatBottomLayout->addStretch();

    this->adminSeatMainLayout = new QVBoxLayout();
    this->adminSeatMainLayout->addStretch();
    this->adminSeatMainLayout->addLayout(this->adminSeatTopLayout);
    this->adminSeatMainLayout->addStretch();
    this->adminSeatMainLayout->addLayout(this->adminSeatBottomLayout);
    this->adminSeatMainLayout->addStretch();
    this->adminSeatMainLayout->addStretch();
    this->adminSeatWindow->setLayout(this->adminSeatMainLayout);

    return this;
}

void MainWindow::adminRenderSeatTable(void) {
    int cnt = this->adminSeatTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->adminSeatTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.exec("SELECT * FROM [Seat]");

    while (query.next()) {
        cnt = this->adminSeatTable->rowCount();
        QString fno = query.value(0).toString();
        int sno = query.value(1).toInt();
        QString type = query.value(2).toString();
        int price = query.value(3).toInt();
        bool state = query.value(4).toBool();
        QString stateStr = (state ? "已售" : "未售");
        this->adminSeatTable->insertRow(cnt);
        this->adminSeatTable->setItem(cnt, 0, new QTableWidgetItem(fno));
        this->adminSeatTable->setItem(cnt, 1, new QTableWidgetItem(QString::number(sno)));
        this->adminSeatTable->setItem(cnt, 2, new QTableWidgetItem(type));
        this->adminSeatTable->setItem(cnt, 3, new QTableWidgetItem(QString::number(price)));
        this->adminSeatTable->setItem(cnt, 4, new QTableWidgetItem(stateStr));
    }

    this->adminSeatTable->resizeColumnsToContents();
    this->adminSeatTable->resizeRowsToContents();
}

void MainWindow::onAdminSeatAddButton(void) {
    QString fno = this->adminSeatFnoEdit->text();
    QString sno = this->adminSeatSnoEdit->text();
    QString type = this->adminSeatTypeEdit->currentText();
    QString price = this->adminSeatPriceEdit->text();
    QRegExpValidator numberRegExp(QRegExp("[0-9]{1,30}"));

    if (fno == "" || sno == "" || type == "" || price == ""
            || !numberRegExp.regExp().exactMatch(sno)
            || !numberRegExp.regExp().exactMatch(price)
            || !this->visitor->addSeat(fno, sno.toInt(), type, price.toInt(), false)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Add Seat Failure!");
    }

    this->adminRenderSeatTable();
}

void MainWindow::onAdminSeatDelButton(void) {
    QString fno = this->adminSeatFnoEdit->text();
    QString sno = this->adminSeatSnoEdit->text();
    QRegExpValidator numberRegExp(QRegExp("[0-9]{1,30}"));

    if (fno == "" || sno == ""
            || !numberRegExp.regExp().exactMatch(sno)
            || !this->visitor->delSeat(fno, sno.toInt())) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Delete Seat Failure!");
    }

    this->adminRenderSeatTable();
}

MainWindow *MainWindow::createVisitorView(void) {
    this->visitorTab = new QTabWidget();
    this->createVisPurchaseWindow();
    this->createVisFetchWindow();
    this->createVisCancelWindow();
    this->createVisBillingWindow();
    this->createVisQueryWindow();

    this->visitorTab->addTab(this->visPurchaseWindow, QIcon(":/at/assets/ticket_purchase.svg"), "Purchase Ticket");
    this->visitorTab->addTab(this->visFetchWindow, QIcon(":/at/assets/ticket_remind.svg"), "Fetch Ticket");
    this->visitorTab->addTab(this->visCancelWindow, QIcon(":/at/assets/ticket_cancel.svg"), "Cancel Ticket");
    this->visitorTab->addTab(this->visBillingWindow, QIcon(":/at/assets/ticket_billing.svg"), "Billing");
    this->visitorTab->addTab(this->visQueryWindow, QIcon(":/at/assets/ticket_data.svg"), "Query");
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
    this->visPurchaseTable->setAlternatingRowColors(true);
    this->visPurchaseTable->setStyleSheet("alternate-background-color: #00695c;");
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
    this->visFetchWindow = new QWidget();
    return this;
}

MainWindow *MainWindow::createVisCancelWindow(void) {
    this->visCancelWindow = new QWidget();
    return this;
}

MainWindow *MainWindow::createVisBillingWindow(void) {
    this->visBillingWindow = new QWidget();
    return this;
}

MainWindow *MainWindow::createVisQueryWindow(void) {
    this->visQueryWindow = new QWidget();
    return this;
}

void MainWindow::onLoginAdminButton(void) {
    QString name = this->loginNameEdit->text();
    QString pwd = this->loginPasswordEdit->text();
    QRegExpValidator nameRegExp(QRegExp("admin"));
    QRegExpValidator pwdRegExp(QRegExp("123456798"));

    if (name == "" || !nameRegExp.regExp().exactMatch(name)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Error Name : must be 'admin'!");
        return ;
    }

    if (pwd == "" || !pwdRegExp.regExp().exactMatch(pwd)) {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Unmatched Password!");
        return ;
    }

    if (this->visitor != nullptr) {
        delete this->visitor;
        this->visitor = nullptr;
    }

    this->visitor = new Visitor("233", name);

    if (this->visitor->state == Visitor::SUCCESS) {
        showMsgBox(":/at/assets/right.png", "Success",
            "Welcome to Air Ticket System");
        this->createAdminView();
        this->setCentralWidget(this->adminTab);
    } else {
        showMsgBox(":/at/assets/warning.png", "Error",
            "Error: database connenction failure!");
    }
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

    if (this->visitor->state == Visitor::SUCCESS) {
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
