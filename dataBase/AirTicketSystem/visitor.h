#ifndef VISITOR_H
#define VISITOR_H

#include <QSqlDatabase>
#include <QString>
#include <QDateTime>
#include <QCryptographicHash>

class Visitor {
public:
    /**
     * @brief 系统状态: 数据库是否连接成功
     */
    enum STATE { FAIL, SUCCESS };
    /**
     * @brief 机票状态：已取票/未取票/已退票
     */
    enum TicketState { FETCHED, UNFETCHED, CANCELED };
    /**
     * @brief 账单类型：付款/退款
     */
    enum BillingType { PAY, REFUND };
    /**
     * @brief 系统当前状态
     */
    int state;
    /**
     * @brief 数据库连接成功后的句柄
     */
    QSqlDatabase db;
    /**
     * @brief 旅客身份证号
     */
    QString id;
    /**
     * @brief 旅客姓名
     */
    QString name;

    Visitor(QString id, QString name);
    ~Visitor(void);

    /**
     * @brief 插入航班信息
     * @param no 航班号
     * @param start 起点
     * @param end 终点
     * @param time 起飞时间
     * @return 数据库操作执行成功性
     */
    bool addFlight(QString no, QString start, QString end, QDateTime time);
    /**
     * @brief 删除航班信息
     * @param no 航班号
     * @return 数据库操作执行成功性
     */
    bool delFlight(QString no);
    /**
     * @brief 插入座位信息
     * @param fno 航班号
     * @param sno 座位号
     * @param type 座位类型
     * @param price 座位价格
     * @param state 座位状态
     * @return 数据库操作执行成功性
     */
    bool addSeat(QString fno, int sno, QString type, int price, bool state);
    /**
     * @brief 删除座位信息
     * @param fno 航班号
     * @param sno 座位号
     * @return 数据库操作执行成功性
     */
    bool delSeat(QString fno, int sno);
    /**
     * @brief 插入机票信息: 座位号顺次分配
     * @param no 航班号
     * @param type 座位类型
     * @return 数据库操作执行成功性
     */
    bool addTicket(QString no, QString type);
    /**
     * @brief 取票操作(包含多个 SQL 操作)
     * @param tno 机票号
     * @return 数据库操作执行成功性
     */
    bool fetchTicket(QString tno);
    /**
     * @brief 退票操作(包含多个 SQL 操作)
     * @param tno 机票号
     * @return 数据库操作执行成功性
     */
    bool cancelTicket(QString tno);

private:
    /**
     * @brief 辅助函数: 利用 MD5 算法生成随机字符串
     * @param seed 作为伪随机字符串的种子
     * @return 随机字符串
     */
    inline QString getRandomStamp(QString seed) {
        return QString(QCryptographicHash::hash(seed.toUtf8(), QCryptographicHash::Md5).toHex()).left(18);
    }

    /**
     * @brief 插入取票信息
     * @param tno 机票号
     * @param fno 航班号
     * @return 数据库操作执行成功性
     */
    bool addRing(QString tno, QString fno);
    /**
     * @brief 删除取票信息
     * @param tno 机票号
     * @return 数据库操作执行成功性
     */
    bool delRing(QString tno);
    /**
     * @brief 插入账单信息
     * @param tno 机票号
     * @param btype 账单类型
     * @return 数据库操作执行成功性
     */
    bool addBilling(QString tno, int btype);
};

#endif // VISITOR_H
