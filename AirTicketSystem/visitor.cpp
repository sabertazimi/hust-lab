#include <QSqlDatabase>
#include <QSqlError>
#include <QString>
#include <QDebug>
#include "visitor.h"

Visitor::Visitor(QString id, QString name) {
    this->db = QSqlDatabase::addDatabase("QODBC", "VisConn");

    this->db.setDatabaseName("Driver={SQL Server};Server=localhost\\HUSTDB;Database=AirTicketSystem");
    this->db.setUserName("sa");
    this->db.setPassword("123456798");
    this->db.setPort(59691);	// exec sys.sp_readerrorlog 0, 1, 'listening'

    bool ok = this->db.open();

    if (ok) {
        this->state = Visitor::VISITOR;
        qDebug() << "Conn Success";
    } else {
        this->state = Visitor::FAIL;
        qDebug() << "Error:" << QSqlError(this->db.lastError()).text();
    }
}

Visitor::~Visitor(void) {
    this->db.close();
}
