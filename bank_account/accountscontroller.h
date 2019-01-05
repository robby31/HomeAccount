#ifndef ACCOUNTSCONTROLLER_H
#define ACCOUNTSCONTROLLER_H

#include <QUrl>
#include <QDir>
#include "mysqldatabase.h"
#include "UIController/controller.h"
#include <QSqlQuery>

class AccountsController : public Controller
{
    Q_OBJECT

public:
    explicit AccountsController(QObject *parent = Q_NULLPTR);

    bool initializeDatabase();

signals:
    void transactionsUpdatedSignal();

    void importQifSignal(const int &idAccount, const QString &fileUrl);

    void createTransactionSignal(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
    void createSplitTransactionSignal(const int &idAccount, const int &idTransaction, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);

public slots:
    void importQif(const int &idAccount, const QString &fileUrl);
    void create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
    void create_split_transaction(const int &idAccount, const int &idTransaction, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
};

#endif // ACCOUNTSCONTROLLER_H
