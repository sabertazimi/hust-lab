#ifndef VISITOR_H
#define VISITOR_H

#include <QSqlDatabase>
#include <QString>
#include <QDateTime>

class Visitor {
public:
    enum STATE { FAIL, SUCCESS };
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

private:
    void exitDB(void);
};

#endif // VISITOR_H
