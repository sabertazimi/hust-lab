#ifndef VISITOR_H
#define VISITOR_H

#include <QString>


class Visitor
{
public:
    Visitor(QString id, QString name);
    ~Visitor(void);
private:
    QString id;
    QString name;
};

#endif // VISITOR_H
