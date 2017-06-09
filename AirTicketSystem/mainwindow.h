#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QWidget>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QLabel>
#include <QPushButton>
#include <QTabWidget>
#include <QMessageBox>
#include <QTableWidget>
#include <QDateTimeEdit>
#include <QComboBox>
#include <visitor.h>

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();
private:
    /**
     * @brief 登录界面
     */
    QWidget *loginMainWindow;
    QVBoxLayout *loginMainLayout;
    QGridLayout *loginTopLayout;
    QHBoxLayout *loginBottomLayout;
    QLineEdit *loginIDEdit;
    QLineEdit *loginNameEdit;
    QLineEdit *loginPasswordEdit;
    QLabel *loginIDLabel;
    QLabel *loginNameLabel;
    QLabel *loginPasswordLabel;
    QPushButton *loginVisitorButton;
    QPushButton *loginAdminButton;

    /**
     * @brief 管理员功能界面
     */
    QTabWidget *adminTab;

    /**
     * @brief 管理员录入航班页
     */
    QWidget *adminFlightWindow;
    QLineEdit *adminFlightNoEdit;
    QLineEdit *adminFlightStartEdit;
    QLineEdit *adminFlightEndEdit;
    QDateTimeEdit *adminFlightTimeEdit;
    QLabel *adminFlightNoLabel;
    QLabel *adminFlightStartLabel;
    QLabel *adminFlightEndLabel;
    QLabel *adminFlightTimeLabel;
    QPushButton *adminFlightAddButton;
    QPushButton *adminFlightDelButton;
    QTableWidget *adminFlightTable;
    QHBoxLayout *adminFlightTopLayout;
    QHBoxLayout *adminFlightBottomLayout;
    QVBoxLayout *adminFlightMainLayout;

    /**
     * @brief 管理员录入座位页
     */
    QWidget *adminSeatWindow;
    QLineEdit *adminSeatFnoEdit;
    QLineEdit *adminSeatSnoEdit;
    QComboBox *adminSeatTypeEdit;
    QLineEdit *adminSeatPriceEdit;
    QLabel *adminSeatFnoLabel;
    QLabel *adminSeatSnoLabel;
    QLabel *adminSeatTypeLabel;
    QLabel *adminSeatPriceLabel;
    QPushButton *adminSeatAddButton;
    QPushButton *adminSeatDelButton;
    QTableWidget *adminSeatTable;
    QHBoxLayout *adminSeatTopLayout;
    QHBoxLayout *adminSeatBottomLayout;
    QVBoxLayout *adminSeatMainLayout;

    /**
     * @brief 旅客功能界面
     */
    QTabWidget *visitorTab;

    /**
     * @brief 旅客订票/查询页
     */
    QWidget *visPurchaseWindow;
    QLineEdit *visPurchaseStartEdit;
    QLineEdit *visPurchaseEndEdit;
    QLineEdit *visPurchaseNoEdit;
    QComboBox *visPurchaseTypeEdit;
    QLabel *visPurchaseStartLabel;
    QLabel *visPurchaseEndLabel;
    QLabel *visPurchaseNoLabel;
    QLabel *visPurchaseTypeLabel;
    QPushButton *visPurchaseQueryButton;
    QPushButton *visPurchaseBookButton;
    QTableWidget *visPurchaseTable;
    QHBoxLayout *visPurchaseTopLayout;
    QHBoxLayout *visPurchaseBottomLayout;
    QVBoxLayout *visPurchaseMainLayout;

    /**
     * @brief 旅客取票页
     */
    QWidget *visFetchWindow;
    QLineEdit *visFetchNoEdit;
    QLabel *visFetchNoLabel;
    QPushButton *visFetchButton;
    QTableWidget *visFetchTable;
    QHBoxLayout *visFetchTopLayout;
    QHBoxLayout *visFetchBottomLayout;
    QVBoxLayout *visFetchMainLayout;

    /**
     * @brief 旅客退票页
     */
    QWidget *visCancelWindow;
    QLineEdit *visCancelNoEdit;
    QLabel *visCancelNoLabel;
    QPushButton *visCancelButton;
    QTableWidget *visCancelTable;
    QHBoxLayout *visCancelTopLayout;
    QHBoxLayout *visCancelBottomLayout;
    QVBoxLayout *visCancelMainLayout;

    /**
     * @brief 旅客账单页
     */
    QWidget *visBillingWindow;
    QTableWidget *visBillingTable;
    QHBoxLayout *visBillingTopLayout;
    QHBoxLayout *visBillingBottomLayout;
    QVBoxLayout *visBillingMainLayout;

    /**
     * @brief 完成增、删、改数据库操作
     */
    Visitor *visitor;

    /**
     * @brief 创建登录界面
     */
    void createLoginView(void);

    /**
     * @brief 创建管理员功能界面
     * 创建航班录入页与座位录入页, 将其渲染至相应的 Tab 上，达到分页的效果
     * 后续的旅客用户界面基本按照此模式进行编写
     */
    void createAdminView(void);
    /**
     * @brief 创建航班录入页
     * 页面设计为双行式布局
     * 上行为 Label/Edit/Button 组成的交互组件
     * 下行为 TableWidget 组成的结果信息
     * 后续所有功能页绘制代码基本按照此模式进行编写
     * 但未对响应函数做任何封装，所以代码可能显得粗暴了些
     */
    void createAdminFlightWindow(void);
    /**
     * @brief 创建座位录入页
     */
    void createAdminSeatWindow(void);

    /**
     * @brief 创建旅客功能界面
     */
    void createVisitorView(void);
    /**
     * @brief 创建订票/查询页
     */
    void createVisPurchaseWindow(void);
    /**
     * @brief 创建取票页
     */
    void createVisFetchWindow(void);
    /**
     * @brief 创建退票页
     */
    void createVisCancelWindow(void);
    /**
     * @brief 创建账单页
     */
    void createVisBillingWindow(void);

    /**
     * @brief 将航班信息表渲染至 UI 表格
     * 利用一个 SQL 查询得到所需数据库表格信息，再将其渲染至 UI 表格
     * 后续所有表格 UI 基本按照此模式编写
     * 但未对表格绘制做任何封装，所以代码十分得粗暴
     * 详细地查阅资料后才发现，利用 QSqlQueryModel 可以无需自己渲染 UI 表格
     * 可以直接将 SQL 查询结果映射至 UI 表格，但此次实验使用的是 QSqlQuery 进行 SQL 操作
     */
    void adminRenderFlightTable(void);
    /**
     * @brief 将座位信息表渲染至 UI 表格
     */
    void adminRenderSeatTable(void);
    /**
     * @brief 将旅客查询航班结果(包括一些统计信息)渲染至 UI 表格
     */
    void visRenderPurchaseTable(void);
    /**
     * @brief 将取票信息表渲染至 UI 表格
     */
    void visRenderFetchTable(void);
    /**
     * @brief 将机(订)票信息表渲染至 UI 表格
     */
    void visRenderCancelTable(void);
    /**
     * @brief 将账单信息表渲染至 UI 表格
     */
    void visRenderBillingTable(void);

    /**
     * @brief 辅助函数：显示拥有自定义图标的消息窗口
     * @param icon 图标路径
     * @param title 窗口标题
     * @param text 信息文本
     */
    inline void showMsgBox(const QString &icon, const QString &title = "Error", const QString &text = "Error") const {
        QMessageBox errorMsg;
        errorMsg.setIconPixmap(QPixmap(icon).scaled(20, 20));
        errorMsg.setWindowTitle(title);
        errorMsg.setText(text);
        errorMsg.exec();
    }

private slots:
    /**
     * @brief 作为旅客登录时的处理函数
     */
    void onLoginVisitorButton(void);
    /**
     * @brief 作为管理员登录时的处理函数
     */
    void onLoginAdminButton(void);

    /**
     * @brief 添加航班信息处理函数
     */
    void onAdminFlightAddButton(void);
    /**
     * @brief 删除航班信息处理函数
     */
    void onAdminFlightDelButton(void);

    /**
     * @brief 添加座位信息处理函数
     */
    void onAdminSeatAddButton(void);
    /**
     * @brief 删除座位信息处理函数
     */
    void onAdminSeatDelButton(void);

    /**
     * @brief 查询处理函数
     */
    void onVisPurchaseQueryButton(void);
    /**
     * @brief 订票处理函数
     */
    void onVisPurchaseBookButton(void);
    /**
     * @brief 取票处理函数
     */
    void onVisFetchButton(void);
    /**
     * @brief 退票处理函数
     */
    void onVisCancelButton(void);
};

#endif // MAINWINDOW_H
