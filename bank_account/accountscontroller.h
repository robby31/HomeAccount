#ifndef ACCOUNTSCONTROLLER_H
#define ACCOUNTSCONTROLLER_H

#include "UIController/controller.h"
#include "Models/sqllistmodel.h"

class AccountsController : public Controller
{
    Q_OBJECT

    Q_PROPERTY(SqlListModel* accountsModel READ accountsModel WRITE setAccountsModel NOTIFY accountsModelChanged)
    Q_PROPERTY(SqlListModel* transactionsModel READ transactionsModel WRITE setTransactionsModel NOTIFY transactionsModelChanged)

public:
    explicit AccountsController(QObject *parent = 0);
    virtual ~AccountsController();

    SqlListModel *accountsModel()       { return m_accountsModel; }
    void setAccountsModel(SqlListModel *model);

    SqlListModel *transactionsModel()   { return m_transactionsModel; }
    void setTransactionsModel(SqlListModel *model);

signals:
    void accountsModelChanged();
    void transactionsModelChanged();

    void loadingSignal(const QString &fileUrl);
    void databaseLoaded(const QString &fileUrl);
    void closeSignal();
    void databaseClosedSignal();

    void importQifSignal(const int &idAccount, const QString &fileUrl);


    void createAccountSignal(const QString &name, const QString &number);
    void createTransactionSignal(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);

private slots:
    void loadDatabase(const QString &fileUrl);
    void databaseOpened(const QString &fileUrl);
    void closeDatabase();
    void importQif(const int &idAccount, const QString &fileUrl);
    void create_account(const QString &name, const QString &number);
    void accountsUpdated();
    void create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
    void transactionsUpdated();


private:
    SqlListModel *m_accountsModel;
    SqlListModel *m_transactionsModel;
};

#endif // ACCOUNTSCONTROLLER_H
