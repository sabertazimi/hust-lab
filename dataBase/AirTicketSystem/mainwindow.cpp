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
#include <QHeaderView>
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
    // 不存在的
}

void MainWindow::createLoginView(void) {
    this->loginMainWindow = new QWidget();

    this->loginIDEdit = new QLineEdit(this->loginMainWindow);
    this->loginNameEdit = new QLineEdit(this->loginMainWindow);
    this->loginPasswordEdit = new QLineEdit(this->loginMainWindow);
    this->loginPasswordEdit->setEchoMode(QLineEdit::Password);
    this->loginIDLabel = new QLabel(QWidget::tr("&旅客身份证号"), this->loginMainWindow);
    this->loginNameLabel = new QLabel(QWidget::tr("&姓名"), this->loginMainWindow);
    this->loginPasswordLabel = new QLabel(QWidget::tr("&管理员密码"), this->loginMainWindow);
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

    this->loginVisitorButton = new QPushButton(QWidget::tr("旅客登录"), this->loginMainWindow);
    this->loginAdminButton = new QPushButton(QWidget::tr("管理员登录"), this->loginMainWindow);
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

    // 双行式布局
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

void MainWindow::createAdminView(void) {
    this->adminTab = new QTabWidget();
    this->createAdminFlightWindow();
    this->createAdminSeatWindow();

    this->adminTab->addTab(this->adminFlightWindow, QIcon(":/at/assets/ticket_purchase.svg"), "航班信息");
    this->adminTab->addTab(this->adminSeatWindow, QIcon(":/at/assets/ticket_data.svg"), "座位信息");
}

void MainWindow::createAdminFlightWindow(void) {
    this->adminFlightWindow = new QWidget();

    this->adminFlightNoEdit = new QLineEdit(this->adminFlightWindow);
    this->adminFlightStartEdit = new QLineEdit(this->adminFlightWindow);
    this->adminFlightEndEdit = new QLineEdit(this->adminFlightWindow);
    this->adminFlightTimeEdit = new QDateTimeEdit(QDateTime::currentDateTime(), this->adminFlightWindow);
    this->adminFlightNoLabel = new QLabel(QWidget::tr("&航班号"), this->adminFlightWindow);
    this->adminFlightStartLabel = new QLabel(QWidget::tr("&起点"), this->adminFlightWindow);
    this->adminFlightEndLabel = new QLabel(QWidget::tr("&终点"), this->adminFlightWindow);
    this->adminFlightTimeLabel = new QLabel(QWidget::tr("&起飞时间"), this->adminFlightWindow);
    this->adminFlightNoLabel->setBuddy(this->adminFlightNoEdit);
    this->adminFlightStartLabel->setBuddy(this->adminFlightStartEdit);
    this->adminFlightEndLabel->setBuddy(this->adminFlightEndEdit);
    this->adminFlightTimeLabel->setBuddy(this->adminFlightTimeEdit);
    this->adminFlightAddButton = new QPushButton(QWidget::tr("添加"), this->adminFlightWindow);
    this->adminFlightDelButton = new QPushButton(QWidget::tr("删除"), this->adminFlightWindow);
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
    this->adminFlightTable->setWindowTitle("航班信息");
    this->adminFlightTable->resize(this->adminFlightTable->maximumWidth(), this->adminFlightTable->maximumHeight());
    this->adminFlightTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->adminFlightTable->setAlternatingRowColors(true);
    this->adminFlightTable->setStyleSheet("alternate-background-color: #aaa;");
    this->adminFlightTable->resizeRowsToContents();
    this->adminFlightTable->setHorizontalHeaderItem(0, new QTableWidgetItem("航班号"));
    this->adminFlightTable->setHorizontalHeaderItem(1, new QTableWidgetItem("起点"));
    this->adminFlightTable->setHorizontalHeaderItem(2, new QTableWidgetItem("终点"));
    this->adminFlightTable->setHorizontalHeaderItem(3, new QTableWidgetItem("起飞时间"));
    this->adminFlightTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    this->adminRenderFlightTable();
    this->adminFlightBottomLayout->addWidget(this->adminFlightTable);

    this->adminFlightMainLayout = new QVBoxLayout();
    this->adminFlightMainLayout->addStretch();
    this->adminFlightMainLayout->addLayout(this->adminFlightTopLayout);
    this->adminFlightMainLayout->addStretch();
    this->adminFlightMainLayout->addLayout(this->adminFlightBottomLayout);
    this->adminFlightMainLayout->addStretch();
    this->adminFlightMainLayout->addStretch();
    this->adminFlightWindow->setLayout(this->adminFlightMainLayout);
}

void MainWindow::adminRenderFlightTable(void) {
    int cnt = this->adminFlightTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->adminFlightTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.exec("SELECT * FROM [Flight];");

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
}

void MainWindow::onAdminFlightAddButton(void) {
    QString no = this->adminFlightNoEdit->text();
    QString start = this->adminFlightStartEdit->text();
    QString end = this->adminFlightEndEdit->text();
    QDateTime time = this->adminFlightTimeEdit->dateTime();

    if (no == "" || start == "" || end == "" || !this->visitor->addFlight(no, start, end, time)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "添加航班失败!");
        return ;
    }

    this->adminRenderFlightTable();
}

void MainWindow::onAdminFlightDelButton(void) {
    QString no = this->adminFlightNoEdit->text();

    if (no == "" || !this->visitor->delFlight(no)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "删除航班失败!");
        return ;
    }

    this->adminRenderFlightTable();
}

void MainWindow::createAdminSeatWindow(void) {
    this->adminSeatWindow = new QWidget();

    this->adminSeatFnoEdit = new QLineEdit(this->adminSeatWindow);
    this->adminSeatSnoEdit = new QLineEdit(this->adminSeatWindow);
    this->adminSeatTypeEdit = new QComboBox(this->adminSeatWindow);
    this->adminSeatTypeEdit->setEditable(true);
    this->adminSeatTypeEdit->insertItem(0, "一等座");
    this->adminSeatTypeEdit->insertItem(1, "二等座");
    this->adminSeatTypeEdit->insertItem(2, "三等座");
    this->adminSeatPriceEdit = new QLineEdit(this->adminSeatWindow);
    this->adminSeatFnoLabel = new QLabel(QWidget::tr("&航班号"), this->adminSeatWindow);
    this->adminSeatSnoLabel = new QLabel(QWidget::tr("&座位号"), this->adminSeatWindow);
    this->adminSeatTypeLabel = new QLabel(QWidget::tr("&座位类型"), this->adminSeatWindow);
    this->adminSeatPriceLabel = new QLabel(QWidget::tr("&座位价格"), this->adminSeatWindow);
    this->adminSeatFnoLabel->setBuddy(this->adminSeatFnoEdit);
    this->adminSeatSnoLabel->setBuddy(this->adminSeatSnoEdit);
    this->adminSeatTypeLabel->setBuddy(this->adminSeatTypeEdit);
    this->adminSeatPriceLabel->setBuddy(this->adminSeatPriceEdit);
    this->adminSeatAddButton = new QPushButton(QWidget::tr("添加"), this->adminSeatWindow);
    this->adminSeatDelButton = new QPushButton(QWidget::tr("删除"), this->adminSeatWindow);
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
    this->adminSeatTable = new QTableWidget(0, 5);
    this->adminSeatTable->setWindowTitle("座位信息");
    this->adminSeatTable->resize(this->adminSeatTable->maximumWidth(), this->adminSeatTable->maximumHeight());
    this->adminSeatTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->adminSeatTable->setAlternatingRowColors(true);
    this->adminSeatTable->setStyleSheet("alternate-background-color: #aaa;");
    this->adminSeatTable->resizeRowsToContents();
    this->adminSeatTable->setHorizontalHeaderItem(0, new QTableWidgetItem("航班号"));
    this->adminSeatTable->setHorizontalHeaderItem(1, new QTableWidgetItem("座位号"));
    this->adminSeatTable->setHorizontalHeaderItem(2, new QTableWidgetItem("座位类型"));
    this->adminSeatTable->setHorizontalHeaderItem(3, new QTableWidgetItem("座位价格"));
    this->adminSeatTable->setHorizontalHeaderItem(4, new QTableWidgetItem("座位状态"));
    this->adminSeatTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    this->adminRenderSeatTable();
    this->adminSeatBottomLayout->addWidget(this->adminSeatTable);

    this->adminSeatMainLayout = new QVBoxLayout();
    this->adminSeatMainLayout->addStretch();
    this->adminSeatMainLayout->addLayout(this->adminSeatTopLayout);
    this->adminSeatMainLayout->addStretch();
    this->adminSeatMainLayout->addLayout(this->adminSeatBottomLayout);
    this->adminSeatMainLayout->addStretch();
    this->adminSeatMainLayout->addStretch();
    this->adminSeatWindow->setLayout(this->adminSeatMainLayout);
}

void MainWindow::adminRenderSeatTable(void) {
    int cnt = this->adminSeatTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->adminSeatTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.exec("SELECT * FROM [Seat];");

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
        showMsgBox(":/at/assets/warning.png", "错误",
            "添加座位失败!");
        return ;
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
        showMsgBox(":/at/assets/warning.png", "错误",
            "删除座位失败!");
        return ;
    }

    this->adminRenderSeatTable();
}

void MainWindow::createVisitorView(void) {
    this->visitorTab = new QTabWidget();
    this->createVisPurchaseWindow();
    this->createVisFetchWindow();
    this->createVisCancelWindow();
    this->createVisBillingWindow();

    this->visitorTab->addTab(this->visPurchaseWindow, QIcon(":/at/assets/ticket_purchase.svg"), "订票");
    this->visitorTab->addTab(this->visFetchWindow, QIcon(":/at/assets/ticket_remind.svg"), "取票");
    this->visitorTab->addTab(this->visCancelWindow, QIcon(":/at/assets/ticket_cancel.svg"), "退票");
    this->visitorTab->addTab(this->visBillingWindow, QIcon(":/at/assets/ticket_billing.svg"), "账单");
}

void MainWindow::createVisPurchaseWindow(void) {
    this->visPurchaseWindow = new QWidget();

    this->visPurchaseStartEdit = new QLineEdit(this->visPurchaseWindow);
    this->visPurchaseStartEdit->setText("Beijing");
    this->visPurchaseEndEdit = new QLineEdit(this->visPurchaseWindow);
    this->visPurchaseEndEdit->setText("Guangzhou");
    this->visPurchaseNoEdit = new QLineEdit(this->visPurchaseWindow);
    this->visPurchaseTypeEdit = new QComboBox(this->visPurchaseWindow);
    this->visPurchaseTypeEdit->setEditable(true);
    this->visPurchaseTypeEdit->insertItem(0, "一等座");
    this->visPurchaseTypeEdit->insertItem(1, "二等座");
    this->visPurchaseTypeEdit->insertItem(2, "三等座");
    this->visPurchaseStartLabel = new QLabel(QWidget::tr("&起点"), this->visPurchaseWindow);
    this->visPurchaseEndLabel = new QLabel(QWidget::tr("&终点"), this->visPurchaseWindow);
    this->visPurchaseNoLabel = new QLabel(QWidget::tr("&航班号"), this->visPurchaseWindow);
    this->visPurchaseTypeLabel = new QLabel(QWidget::tr("&座位类型"), this->visPurchaseWindow);
    this->visPurchaseStartLabel->setBuddy(this->visPurchaseStartEdit);
    this->visPurchaseEndLabel->setBuddy(this->visPurchaseEndEdit);
    this->visPurchaseNoLabel->setBuddy(this->visPurchaseNoEdit);
    this->visPurchaseTypeLabel->setBuddy(this->visPurchaseTypeEdit);
    this->visPurchaseQueryButton = new QPushButton(QWidget::tr("查询"), this->visPurchaseWindow);
    this->visPurchaseBookButton = new QPushButton(QWidget::tr("订票"), this->visPurchaseWindow);
    connect(this->visPurchaseQueryButton, SIGNAL(released()), this, SLOT(onVisPurchaseQueryButton()));
    connect(this->visPurchaseBookButton, SIGNAL(released()), this, SLOT(onVisPurchaseBookButton()));
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
    this->visPurchaseTopLayout->addWidget(this->visPurchaseQueryButton);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addWidget(this->visPurchaseNoLabel);
    this->visPurchaseTopLayout->addWidget(this->visPurchaseNoEdit);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addWidget(this->visPurchaseTypeLabel);
    this->visPurchaseTopLayout->addWidget(this->visPurchaseTypeEdit);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addWidget(this->visPurchaseBookButton);
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addStretch();
    this->visPurchaseTopLayout->addStretch();

    this->visPurchaseBottomLayout = new QHBoxLayout();
    this->visPurchaseTable = new QTableWidget(0, 7);
    this->visPurchaseTable->setWindowTitle("航班信息");
    this->visPurchaseTable->resize(this->visPurchaseTable->maximumWidth(), this->visPurchaseTable->maximumHeight());
    this->visPurchaseTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->visPurchaseTable->setAlternatingRowColors(true);
    this->visPurchaseTable->setStyleSheet("alternate-background-color: #aaa;");
    this->visPurchaseTable->resizeRowsToContents();
    this->visPurchaseTable->setHorizontalHeaderItem(0, new QTableWidgetItem("航班号"));
    this->visPurchaseTable->setHorizontalHeaderItem(1, new QTableWidgetItem("起点"));
    this->visPurchaseTable->setHorizontalHeaderItem(2, new QTableWidgetItem("终点"));
    this->visPurchaseTable->setHorizontalHeaderItem(3, new QTableWidgetItem("起飞时间"));
    this->visPurchaseTable->setHorizontalHeaderItem(4, new QTableWidgetItem("座位类型"));
    this->visPurchaseTable->setHorizontalHeaderItem(5, new QTableWidgetItem("座位均价"));
    this->visPurchaseTable->setHorizontalHeaderItem(6, new QTableWidgetItem("满座率"));
    this->visPurchaseTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    this->visPurchaseBottomLayout->addWidget(this->visPurchaseTable);

    this->visPurchaseMainLayout = new QVBoxLayout();
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseMainLayout->addLayout(this->visPurchaseTopLayout);
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseMainLayout->addLayout(this->visPurchaseBottomLayout);
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseMainLayout->addStretch();
    this->visPurchaseWindow->setLayout(this->visPurchaseMainLayout);
}

void MainWindow::visRenderPurchaseTable(void) {
    QString fstart = this->visPurchaseStartEdit->text();
    QString fend = this->visPurchaseEndEdit->text();

    if (fstart == "" || fend == "") {
        return ;
    }

    int cnt = this->visPurchaseTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->visPurchaseTable->removeRow(0);
    }

    QSqlQuery query1(this->visitor->db);
    QSqlQuery query2(this->visitor->db);
    // query flights with empty seats
    query1.prepare("SELECT [Flight].[Fno], [Start], [End], [Ftime], [Stype], AVG([Sprice]) AS [Price], COUNT(*) AS [Space]"
                  "FROM [Flight], [Seat]"
                  "WHERE [Flight].[Fno] = [Seat].[Fno] AND [Sstate] = 0"
                  "AND [Start] = :start AND [End] = :end GROUP BY [Flight].[Fno], [Start], [End], [Ftime], [Stype];");
    query1.bindValue(":start", fstart);
    query1.bindValue(":end", fend);
    query2.prepare("SELECT COUNT(*) AS [Sum]"
                  "FROM [Flight], [Seat]"
                  "WHERE [Flight].[Fno] = [Seat].[Fno]"
                  "AND [Start] = :start AND [End] = :end GROUP BY [Flight].[Fno], [Stype];");
    query2.bindValue(":start", fstart);
    query2.bindValue(":end", fend);
    if (!query1.exec() || !query2.exec()) {
        return ;
    }

    while (query1.next() && query2.next()) {
        QString no = query1.value(0).toString();
        QString start = query1.value(1).toString();
        QString end = query1.value(2).toString();
        QDateTime time = query1.value(3).toDateTime();
        QString type = query1.value(4).toString();
        int price = query1.value(5).toInt();
        int space = query1.value(6).toInt();
        int sum = query2.value(0).toInt();
        double rate = (1 - (space * 1.0 / sum)) * 100;

        cnt = this->visPurchaseTable->rowCount();
        this->visPurchaseTable->insertRow(cnt);
        this->visPurchaseTable->setItem(cnt, 0, new QTableWidgetItem(no));
        this->visPurchaseTable->setItem(cnt, 1, new QTableWidgetItem(start));
        this->visPurchaseTable->setItem(cnt, 2, new QTableWidgetItem(end));
        this->visPurchaseTable->setItem(cnt, 3, new QTableWidgetItem(time.toString()));
        this->visPurchaseTable->setItem(cnt, 4, new QTableWidgetItem(type));
        this->visPurchaseTable->setItem(cnt, 5, new QTableWidgetItem(QString::number(price)));
        this->visPurchaseTable->setItem(cnt, 6, new QTableWidgetItem(QString::number(rate) + " %"));
    }
}

void MainWindow::onVisPurchaseQueryButton(void) {
    this->visRenderPurchaseTable();
}

void MainWindow::onVisPurchaseBookButton(void) {
    QString no = this->visPurchaseNoEdit->text();
    QString type = this->visPurchaseTypeEdit->currentText();

    if (no == "" || !this->visitor->addTicket(no, type)) {
        showMsgBox(":/at/assets/warning.png", "抱歉",
            "已无余票!");
        return ;
    } else {
        showMsgBox(":/at/assets/right.png", "成功",
            "订票成功!");
    }

    this->visRenderPurchaseTable();
    this->visRenderFetchTable();
    this->visRenderCancelTable();
    this->visRenderBillingTable();
}

void MainWindow::createVisFetchWindow(void) {
    this->visFetchWindow = new QWidget();

    this->visFetchNoEdit = new QLineEdit(this->visFetchWindow);
    this->visFetchNoLabel = new QLabel(QWidget::tr("&机票号"), this->visFetchWindow);
    this->visFetchNoLabel->setBuddy(this->visFetchNoEdit);
    this->visFetchButton = new QPushButton(QWidget::tr("取票"), this->visFetchWindow);
    connect(this->visFetchButton, SIGNAL(released()), this, SLOT(onVisFetchButton()));
    this->visFetchTopLayout = new QHBoxLayout();
    this->visFetchTopLayout->addStretch();
    this->visFetchTopLayout->addWidget(this->visFetchNoLabel);
    this->visFetchTopLayout->addWidget(this->visFetchNoEdit);
    this->visFetchTopLayout->addWidget(this->visFetchButton);
    this->visFetchTopLayout->addStretch();

    this->visFetchBottomLayout = new QHBoxLayout();
    this->visFetchTable = new QTableWidget(0, 2);
    this->visFetchTable->setWindowTitle("取票提醒");
    this->visFetchTable->resize(this->visFetchTable->maximumWidth(), this->visFetchTable->maximumHeight());
    this->visFetchTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->visFetchTable->setAlternatingRowColors(true);
    this->visFetchTable->setStyleSheet("alternate-background-color: #aaa;");
    this->visFetchTable->resizeRowsToContents();
    this->visFetchTable->setHorizontalHeaderItem(0, new QTableWidgetItem("机票号"));
    this->visFetchTable->setHorizontalHeaderItem(1, new QTableWidgetItem("取票截止时间"));
    this->visFetchTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    this->visRenderFetchTable();
    this->visFetchBottomLayout->addWidget(this->visFetchTable);

    this->visFetchMainLayout = new QVBoxLayout();
    this->visFetchMainLayout->addStretch();
    this->visFetchMainLayout->addLayout(this->visFetchTopLayout);
    this->visFetchMainLayout->addStretch();
    this->visFetchMainLayout->addLayout(this->visFetchBottomLayout);
    this->visFetchMainLayout->addStretch();
    this->visFetchMainLayout->addStretch();
    this->visFetchWindow->setLayout(this->visFetchMainLayout);
}

void MainWindow::visRenderFetchTable(void) {
    int cnt = this->visFetchTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->visFetchTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.prepare("SELECT [Ring].[Tno], [Rtime] FROM [Ticket], [Ring]"
                  "WHERE [Ticket].[Tno] = [Ring].[Tno] AND [Vid] = :vid;");
    query.bindValue(":vid", this->visitor->id);
    if (!query.exec()) {
        return ;
    }

    while (query.next()) {
        QString tno = query.value(0).toString();
        QDateTime rtime = query.value(1).toDateTime();
        cnt = this->visFetchTable->rowCount();
        this->visFetchTable->insertRow(cnt);
        this->visFetchTable->setItem(cnt, 0, new QTableWidgetItem(tno));
        this->visFetchTable->setItem(cnt, 1, new QTableWidgetItem(rtime.toString()));
    }
}

void MainWindow::onVisFetchButton(void) {
    QString tno = this->visFetchNoEdit->text();

    if (tno == "" || !this->visitor->fetchTicket(tno)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "取票失败!");
        return ;
    }

    this->visRenderPurchaseTable();
    this->visRenderFetchTable();
    this->visRenderCancelTable();
}

void MainWindow::createVisCancelWindow(void) {
    this->visCancelWindow = new QWidget();

    this->visCancelNoEdit = new QLineEdit(this->visCancelWindow);
    this->visCancelNoLabel = new QLabel(QWidget::tr("&机票号"), this->visCancelWindow);
    this->visCancelNoLabel->setBuddy(this->visCancelNoEdit);
    this->visCancelButton = new QPushButton(QWidget::tr("退票"), this->visCancelWindow);
    connect(this->visCancelButton, SIGNAL(released()), this, SLOT(onVisCancelButton()));
    this->visCancelTopLayout = new QHBoxLayout();
    this->visCancelTopLayout->addStretch();
    this->visCancelTopLayout->addWidget(this->visCancelNoLabel);
    this->visCancelTopLayout->addWidget(this->visCancelNoEdit);
    this->visCancelTopLayout->addWidget(this->visCancelButton);
    this->visCancelTopLayout->addStretch();

    this->visCancelBottomLayout = new QHBoxLayout();
    this->visCancelTable = new QTableWidget(0, 8);
    this->visCancelTable->setWindowTitle("机票信息");
    this->visCancelTable->resize(this->visCancelTable->maximumWidth(), this->visCancelTable->maximumHeight());
    this->visCancelTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->visCancelTable->setAlternatingRowColors(true);
    this->visCancelTable->setStyleSheet("alternate-background-color: #aaa;");
    this->visCancelTable->resizeRowsToContents();
    this->visCancelTable->setHorizontalHeaderItem(0, new QTableWidgetItem("机票号"));
    this->visCancelTable->setHorizontalHeaderItem(1, new QTableWidgetItem("航班号"));
    this->visCancelTable->setHorizontalHeaderItem(2, new QTableWidgetItem("座位号"));
    this->visCancelTable->setHorizontalHeaderItem(3, new QTableWidgetItem("起点"));
    this->visCancelTable->setHorizontalHeaderItem(4, new QTableWidgetItem("终点"));
    this->visCancelTable->setHorizontalHeaderItem(5, new QTableWidgetItem("起飞时间"));
    this->visCancelTable->setHorizontalHeaderItem(6, new QTableWidgetItem("座位类型"));
    this->visCancelTable->setHorizontalHeaderItem(7, new QTableWidgetItem("座位价格"));
    this->visCancelTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    this->visRenderCancelTable();
    this->visCancelBottomLayout->addWidget(this->visCancelTable);

    this->visCancelMainLayout = new QVBoxLayout();
    this->visCancelMainLayout->addStretch();
    this->visCancelMainLayout->addLayout(this->visCancelTopLayout);
    this->visCancelMainLayout->addStretch();
    this->visCancelMainLayout->addLayout(this->visCancelBottomLayout);
    this->visCancelMainLayout->addStretch();
    this->visCancelMainLayout->addStretch();
    this->visCancelWindow->setLayout(this->visCancelMainLayout);
}

void MainWindow::visRenderCancelTable(void) {
    int cnt = this->visCancelTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->visCancelTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.prepare("SELECT [Tno], [Flight].[Fno], [Seat].[Sno], [Start], [End], [Ftime], [Stype], [Sprice]"
                  "FROM [Flight], [Seat], [Ticket]"
                  "WHERE [Ticket].[Fno] = [Flight].[Fno] AND [Ticket].[Fno] = [Seat].[Fno]"
                  "AND [Ticket].[Sno] = [Seat].[Sno] AND [Tstate] = :tstate AND [Vid] = :vid;");
    // only unfetched tickets can be cancelled
    query.bindValue(":tstate", Visitor::UNFETCHED);
    query.bindValue(":vid", this->visitor->id);
    if (!query.exec()) {
        return ;
    }

    while (query.next()) {
        QString tno = query.value(0).toString();
        QString fno = query.value(1).toString();
        QString sno = query.value(2).toString();
        QString start = query.value(3).toString();
        QString end = query.value(4).toString();
        QDateTime ftime = query.value(5).toDateTime();
        QString type = query.value(6).toString();
        int price = query.value(7).toInt();

        cnt = this->visCancelTable->rowCount();
        this->visCancelTable->insertRow(cnt);
        this->visCancelTable->setItem(cnt, 0, new QTableWidgetItem(tno));
        this->visCancelTable->setItem(cnt, 1, new QTableWidgetItem(fno));
        this->visCancelTable->setItem(cnt, 2, new QTableWidgetItem(sno));
        this->visCancelTable->setItem(cnt, 3, new QTableWidgetItem(start));
        this->visCancelTable->setItem(cnt, 4, new QTableWidgetItem(end));
        this->visCancelTable->setItem(cnt, 5, new QTableWidgetItem(ftime.toString()));
        this->visCancelTable->setItem(cnt, 6, new QTableWidgetItem(type));
        this->visCancelTable->setItem(cnt, 7, new QTableWidgetItem(QString::number(price)));
    }
}

void MainWindow::onVisCancelButton(void) {
    QString tno = this->visCancelNoEdit->text();

    if (tno == "" || !this->visitor->cancelTicket(tno)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "退票失败!");
        return ;
    }

    this->visRenderPurchaseTable();
    this->visRenderFetchTable();
    this->visRenderCancelTable();
    this->visRenderBillingTable();
}

void MainWindow::createVisBillingWindow(void) {
    this->visBillingWindow = new QWidget();

    this->visBillingTopLayout = new QHBoxLayout();
    this->visBillingTopLayout->addStretch();

    this->visBillingBottomLayout = new QHBoxLayout();
    this->visBillingTable = new QTableWidget(0, 5);
    this->visBillingTable->setWindowTitle("账单");
    this->visBillingTable->resize(this->visBillingTable->maximumWidth(), this->visBillingTable->maximumHeight());
    this->visBillingTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    this->visBillingTable->setAlternatingRowColors(true);
    this->visBillingTable->setStyleSheet("alternate-background-color: #aaa;");
    this->visBillingTable->resizeRowsToContents();
    this->visBillingTable->setHorizontalHeaderItem(0, new QTableWidgetItem("账单号"));
    this->visBillingTable->setHorizontalHeaderItem(1, new QTableWidgetItem("账单类型"));
    this->visBillingTable->setHorizontalHeaderItem(2, new QTableWidgetItem("机票号"));
    this->visBillingTable->setHorizontalHeaderItem(3, new QTableWidgetItem("价格"));
    this->visBillingTable->setHorizontalHeaderItem(4, new QTableWidgetItem("账单时间"));
    this->visBillingTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    this->visRenderBillingTable();
    this->visBillingBottomLayout->addWidget(this->visBillingTable);

    this->visBillingMainLayout = new QVBoxLayout();
    this->visBillingMainLayout->addStretch();
    this->visBillingMainLayout->addLayout(this->visBillingTopLayout);
    this->visBillingMainLayout->addStretch();
    this->visBillingMainLayout->addLayout(this->visBillingBottomLayout);
    this->visBillingMainLayout->addStretch();
    this->visBillingMainLayout->addStretch();
    this->visBillingWindow->setLayout(this->visBillingMainLayout);
}

void MainWindow::visRenderBillingTable(void) {
    int cnt = this->visBillingTable->rowCount();

    for (int i = 0; i < cnt; i++) {
        this->visBillingTable->removeRow(0);
    }

    QSqlQuery query(this->visitor->db);
    query.prepare("SELECT [Bno], [Btype], [Bill].[Tno], [Sprice], [Btime]"
                  "FROM [Seat], [Ticket], [Bill]"
                  "WHERE [Bill].[Tno] = [Ticket].[Tno] AND [Ticket].[Fno] = [Seat].[Fno]"
                  "AND [Ticket].[Sno] = [Seat].[Sno] AND [Vid] = :vid ORDER BY [Btime];");
    query.bindValue(":vid", this->visitor->id);
    if (!query.exec()) {
        return ;
    }

    while (query.next()) {
        QString bno = query.value(0).toString();
        int type = query.value(1).toInt();
        QString typeStr = (type == Visitor::PAY ? "付款" : "退款");
        QString tno = query.value(2).toString();
        int price = query.value(3).toInt();
        QDateTime btime = query.value(4).toDateTime();

        cnt = this->visBillingTable->rowCount();
        this->visBillingTable->insertRow(cnt);
        this->visBillingTable->setItem(cnt, 0, new QTableWidgetItem(bno));
        this->visBillingTable->setItem(cnt, 1, new QTableWidgetItem(typeStr));
        this->visBillingTable->setItem(cnt, 2, new QTableWidgetItem(tno));
        this->visBillingTable->setItem(cnt, 3, new QTableWidgetItem(QString::number(price)));
        this->visBillingTable->setItem(cnt, 4, new QTableWidgetItem(btime.toString()));
    }
}

void MainWindow::onLoginAdminButton(void) {
    QString name = this->loginNameEdit->text();
    QString pwd = this->loginPasswordEdit->text();
    QRegExpValidator nameRegExp(QRegExp("admin"));
    QRegExpValidator pwdRegExp(QRegExp("123456798"));

    if (name == "" || !nameRegExp.regExp().exactMatch(name)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "登录名或密码错误!");
        return ;
    }

    if (pwd == "" || !pwdRegExp.regExp().exactMatch(pwd)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "登录名或密码错误!");
        return ;
    }

    if (this->visitor != nullptr) {
        delete this->visitor;
        this->visitor = nullptr;
    }

    this->visitor = new Visitor("233", name);

    if (this->visitor->state == Visitor::SUCCESS) {
        showMsgBox(":/at/assets/right.png", "成功",
            "欢迎来到机票管理系统");
        this->createAdminView();
        this->setCentralWidget(this->adminTab);
    } else {
        showMsgBox(":/at/assets/warning.png", "错误",
            "数据库连接失败!");
    }
}

void MainWindow::onLoginVisitorButton(void) {
    QString id = this->loginIDEdit->text();
    QString name = this->loginNameEdit->text();
    QRegExpValidator idRegExp(QRegExp("[0-9]{14}[0-9X]{4}"));
    QRegExpValidator nameRegExp(QRegExp("[A-Za-z0-9_]{6,30}"));

    if (id == "" || !idRegExp.regExp().exactMatch(id)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "无效的身份证号!");
            return ;
    }

    if (name == "" || !nameRegExp.regExp().exactMatch(name)) {
        showMsgBox(":/at/assets/warning.png", "错误",
            "无效(或过短)的用户名(只可含有字母)!");
            return ;
    }

    if (this->visitor != nullptr) {
        delete this->visitor;
        this->visitor = nullptr;
    }

    this->visitor = new Visitor(id, name);

    if (this->visitor->state == Visitor::SUCCESS) {
        showMsgBox(":/at/assets/right.png", "成功",
            "欢饮来到机票管理系统!");
        this->createVisitorView();
        this->setCentralWidget(this->visitorTab);
    } else {
        showMsgBox(":/at/assets/warning.png", "错误",
            "数据库连接失败!");
    }
}
