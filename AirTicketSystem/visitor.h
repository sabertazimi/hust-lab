#ifndef VISITOR_H
#define VISITOR_H

#include <QSqlDatabase>
#include <QString>

class Visitor {
public:
    enum STATE { FAIL, ADMIN, VISITOR };
    Visitor(QString id, QString name);
    ~Visitor(void);
    int state;
    QSqlDatabase db;
    QString id;
    QString name;
};

#endif // VISITOR_H
