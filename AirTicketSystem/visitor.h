#ifndef VISITOR_H
#define VISITOR_H

#include <QSqlDatabase>
#include <QString>
#include <QDateTime>
#include <QCryptographicHash>

class Visitor {
public:
    enum STATE { FAIL, SUCCESS };
    enum TicketState { FETCHED, UNFETCHED, CANCELED };
    enum BillingType { PAY, REFUND };
    int state;
    QSqlDatabase db;
    QString id;
    QString name;

    Visitor(QString id, QString name);
    ~Visitor(void);
    bool addFlight(QString no, QString start, QString end, QDateTime time);
    bool delFlight(QString no);
    bool addSeat(QString fno, int sno, QString type, int price, bool state);
    bool delSeat(QString fno, int sno);
    bool addTicket(QString no, QString type);
    bool fetchTicket(QString tno);
    bool cancelTicket(QString tno);

private:
    inline QString getRandomStamp(QString seed) {
        return QString(QCryptographicHash::hash(seed.toUtf8(), QCryptographicHash::Md5).toHex()).left(18);
    }

    // trigger
    bool addRing(QString tno, QString fno);
    bool delRing(QString tno);
    bool addBilling(QString tno, int btype);
};

#endif // VISITOR_H
