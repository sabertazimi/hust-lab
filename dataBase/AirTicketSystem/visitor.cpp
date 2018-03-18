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
    this->db.close();
}

bool Visitor::addFlight(QString no, QString start, QString end, QDateTime time) {
    QSqlQuery query(this->db);

    query.prepare("INSERT INTO [Flight]([Fno], [Start], [End], [Ftime])"
                  "VALUES (:no, :start, :end, :time);");
    query.bindValue(":no", no);
    query.bindValue(":start", start);
    query.bindValue(":end", end);
    query.bindValue(":time", time);

    return query.exec();
}

bool Visitor::delFlight(QString no) {
    QSqlQuery query(this->db);

    query.prepare("DELETE FROM [Flight]"
                  "WHERE [Fno] = :no;");
    query.bindValue(":no", no);

    return query.exec();
}

bool Visitor::addSeat(QString fno, int sno, QString type, int price, bool state) {
    QSqlQuery query(this->db);

    query.prepare("INSERT INTO [Seat]([Fno], [Sno], [Stype], [Sprice], [Sstate])"
                  "VALUES (:fno, :sno, :type, :price, :state);");
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
                  "WHERE [Fno] = :fno AND [Sno] = :sno;");
    query.bindValue(":fno", fno);
    query.bindValue(":sno", sno);

    return query.exec();
}

bool Visitor::addTicket(QString fno, QString type) {
    QSqlQuery query1(this->db);
    query1.prepare("SELECT TOP 1 [Sno] FROM [Seat]"
                   "WHERE [Fno] = :fno AND [Stype] = :type AND [Sstate] = 0 ORDER BY [Sno];");
    query1.bindValue(":fno", fno);
    query1.bindValue(":type", type);
    if (!query1.exec() || !query1.next()) {
        return false;
    }

    // get Sno to change
    QString sno = query1.value(0).toString();
    QSqlQuery query2(this->db);
    query2.prepare("UPDATE [Seat]"
                  "SET [Sstate] = 1"
                  "WHERE [Fno] = :fno AND [Sno] = :sno AND [Sstate] = 0;");
    query2.bindValue(":fno", fno);
    query2.bindValue(":sno", sno);
    if (!query2.exec()) {
        return false;
    }

    QString tno = this->getRandomStamp(QDateTime::currentDateTime().toString());
    QSqlQuery query3(this->db);
    query3.prepare("INSERT INTO [Ticket]"
                   "VALUES (:tno, :fno, :sno, :vid, :tstate, :ttime);");
    query3.bindValue(":tno", tno);
    query3.bindValue(":fno", fno);
    query3.bindValue(":sno", sno.toInt());
    query3.bindValue(":vid", this->id);
    query3.bindValue(":tstate", Visitor::UNFETCHED);
    query3.bindValue(":ttime", QDateTime::currentDateTime());
    if (!query3.exec()) {
        return false;
    }

    return this->addRing(tno, fno) && this->addBilling(tno, Visitor::PAY);
}

bool Visitor::fetchTicket(QString tno) {
    QSqlQuery query(this->db);
    query.prepare("UPDATE [Ticket]"
                   "SET [Tstate] = :tstate WHERE [Tno] = :tno;");
    query.bindValue(":tno", tno);
    query.bindValue(":tstate", Visitor::FETCHED);
    if (!query.exec()) {
        return false;
    }

    return this->delRing(tno);
}

bool Visitor::cancelTicket(QString tno) {
    QSqlQuery query1(this->db);
    query1.prepare("SELECT [Fno], [Sno] FROM [Ticket]"
                   "WHERE [Tno] = :tno;");
    query1.bindValue(":tno", tno);
    if (!query1.exec() || !query1.next()) {
        return false;
    }

    // get Sno to change
    QString fno = query1.value(0).toString();
    QString sno = query1.value(1).toString();
    QSqlQuery query2(this->db);
    query2.prepare("UPDATE [Seat]"
                  "SET [Sstate] = 0"
                  "WHERE [Fno] = :fno AND [Sno] = :sno AND [Sstate] = 1;");
    query2.bindValue(":fno", fno);
    query2.bindValue(":sno", sno);
    if (!query2.exec()) {
        return false;
    }

    QSqlQuery query3(this->db);
    query3.prepare("UPDATE [Ticket]"
                   "SET [Tstate] = :tstate WHERE [Tno] = :tno;");
    query3.bindValue(":tstate", Visitor::CANCELED);
    query3.bindValue(":tno", tno);
    if (!query3.exec()) {
        return false;
    }

    return this->delRing(tno) && this->addBilling(tno, Visitor::REFUND);
}

bool Visitor::addRing(QString tno, QString fno) {
    QSqlQuery query1(this->db);
    query1.prepare("SELECT [Ftime] FROM [Flight], [Ticket]"
                   "WHERE [Flight].[Fno] = [Ticket].[Fno] AND [Tno] = :tno AND [Ticket].[Fno] = :fno");
    query1.bindValue(":tno", tno);
    query1.bindValue(":fno", fno);
    if (!query1.exec() || !query1.next()) {
        return false;
    }

    QDateTime rtime = query1.value(0).toDateTime();
    QSqlQuery query2(this->db);
    query2.prepare("INSERT INTO [Ring]"
                   "VALUES (:tno, :rtime);");
    query2.bindValue(":tno", tno);
    query2.bindValue(":rtime", rtime);

    return query2.exec();
}

bool Visitor::delRing(QString tno) {
    QSqlQuery query(this->db);
    query.prepare("DELETE FROM [Ring]"
                   "WHERE [Tno] = :tno;");
    query.bindValue(":tno", tno);

    return query.exec();
}


bool Visitor::addBilling(QString tno, int btype) {
    QString bno = this->getRandomStamp(QDateTime::currentDateTime().toString() + QDate::currentDate().toString());
    QSqlQuery query(this->db);

    query.prepare("INSERT INTO [Bill]"
                   "VALUES (:bno, :btype, :tno, :btime);");
    query.bindValue(":bno", bno);
    query.bindValue(":btype", btype);
    query.bindValue(":tno", tno);
    query.bindValue(":btime", QDateTime::currentDateTime());

    return query.exec();
}




