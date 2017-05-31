#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QString>
#include <QDebug>
#include "visitor.h"

Visitor::Visitor(QString id, QString name) {
    this->id = id;
    this->name = name;

    this->db = QSqlDatabase::addDatabase("QODBC", "VisConn");

    this->db.setDatabaseName("Driver={SQL Server};Server=localhost\\HUSTDB;Database=AirTicketSystem");
    this->db.setUserName("sa");
    this->db.setPassword("123456798");
    this->db.setPort(59691);	// exec sys.sp_readerrorlog 0, 1, 'listening'

    if (this->db.open()) {
        this->state = Visitor::SUCCESS;
        qDebug() << "Conn Success";
    } else {
        this->state = Visitor::FAIL;
        qDebug() << "Error:" << QSqlError(this->db.lastError()).text();
    }
}

Visitor::~Visitor(void) {
    this->exitDB();
}

bool Visitor::addFlight(QString no, QString start, QString end, QDateTime time) {
    QSqlQuery query(this->db);

    query.prepare("INSERT INTO [Flight]([Fno], [Start], [End], [Ftime])"
                  "VALUES (:no, :start, :end, :time)");
    query.bindValue(":no", no);
    query.bindValue(":start", start);
    query.bindValue(":end", end);
    query.bindValue(":time", time);

    return query.exec();
}

bool Visitor::delFlight(QString no) {
    QSqlQuery query(this->db);

    query.prepare("DELETE FROM [Flight]"
                  "WHERE [Fno] = :no");
    query.bindValue(":no", no);

    return query.exec();
}

bool Visitor::addSeat(QString fno, int sno, QString type, int price, bool state) {
    QSqlQuery query(this->db);

    query.prepare("INSERT INTO [Seat]([Fno], [Sno], [Stype], [Sprice], [Sstate])"
                  "VALUES (:fno, :sno, :type, :price, :state)");
    query.bindValue(":fno", fno);
    query.bindValue(":sno", sno);
    query.bindValue(":type", type);
    query.bindValue(":price", price);
    query.bindValue(":state", state);

    return query.exec();
}

bool Visitor::delSeat(QString fno, int sno) {
    QSqlQuery query(this->db);

    query.prepare("DELETE FROM [Seat]"
                  "WHERE [Fno] = :fno AND [Sno] = :sno");
    query.bindValue(":fno", fno);
    query.bindValue(":sno", sno);

    return query.exec();
}

void Visitor::exitDB(void) {
    this->db.close();
}
