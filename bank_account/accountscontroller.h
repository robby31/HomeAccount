#ifndef ACCOUNTSCONTROLLER_H
#define ACCOUNTSCONTROLLER_H

#include <QSqlDatabase>
#include <QUrl>
#include <QDir>
#include "mysqldatabase.h"
#include "UIController/controller.h"

class AccountsController : public Controller
{
    Q_OBJECT

public:
    explicit AccountsController(QObject *parent = 0);
    virtual ~AccountsController();


signals:
    void loadingSignal(const QString &fileUrl);
    void databaseLoaded(const QString &fileUrl);
    void closeSignal();
    void databaseClosedSignal();
    void accountsUpdatedSignal();
    void transactionsUpdatedSignal();

    void importQifSignal(const int &idAccount, const QString &fileUrl);


    void createAccountSignal(const QString &name, const QString &number);
    void createTransactionSignal(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);

private slots:
    void loadDatabase(const QString &fileUrl);
    void databaseOpened(const QString &fileUrl);
    void closeDatabase();
    void importQif(const int &idAccount, const QString &fileUrl);
    void create_account(const QString &name, const QString &number);
    void create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
};

#endif // ACCOUNTSCONTROLLER_H
