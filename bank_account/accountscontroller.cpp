#include "accountscontroller.h"

AccountsController::AccountsController(QObject *parent):
    Controller(parent),
    m_accountsModel(0),
    m_transactionsModel(0)
{
    CREATE_DATABASE("QSQLITE", "ACCOUNTS");
}

AccountsController::~AccountsController()
{
    if (m_accountsModel)
        m_accountsModel->deleteLater();
    if (m_transactionsModel)
        m_transactionsModel->deleteLater();
}

void AccountsController::loadDatabase(const QString &fileUrl)
{
    if (setActivity("LOADING"))
    {
        QSqlDatabase db = GET_DATABASE("ACCOUNTS");

        if (db.isOpen())
            db.close();

        QString filename = QUrl::fromUserInput(fileUrl).toLocalFile();
        db.setDatabaseName(QDir::toNativeSeparators(filename));

        if (db.open())
            emit loadingSignal(fileUrl);
        else
            emit errorDuringProcess("unable to open database");
    }
}

void AccountsController::databaseOpened(const QString &fileUrl)
{
    Q_UNUSED(fileUrl)

    setAccountsModel(new SqlListModel());
    m_accountsModel->setConnectionName("ACCOUNTS");
    m_accountsModel->setQuery("SELECT id, name, number, (SELECT SUM(transactions.amount) FROM transactions WHERE transactions.account_id=accounts.id and split_id=0) AS amount FROM accounts");

    setTransactionsModel(new SqlListModel());
    m_transactionsModel->setConnectionName("ACCOUNTS");

    emit databaseLoaded(fileUrl);
}

void AccountsController::closeDatabase()
{
    if (setActivity("CLOSE"))
    {
        QSqlDatabase db = GET_DATABASE("ACCOUNTS");

        db.close();

        emit closeSignal();
    }
}

void AccountsController::importQif(const int &idAccount, const QString &fileUrl)
{
    if (setActivity("Import QIF"))
        emit importQifSignal(idAccount, fileUrl);
}


void AccountsController::create_account(const QString &name, const QString &number)
{
    if (setActivity("Create Account"))
        emit createAccountSignal(name, number);
}

void AccountsController::accountsUpdated()
{
    m_accountsModel->reload();
}

void AccountsController::create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount)
{
    if (setActivity("Create Transaction"))
        emit createTransactionSignal(idAccount, date, payee, memo, amount);
}

void AccountsController::transactionsUpdated()
{
    m_transactionsModel->reload();

    // update model to update amount of the changed account
    m_accountsModel->reload();
}

void AccountsController::setAccountsModel(SqlListModel *model)
{
    if (m_accountsModel)
    {
        m_accountsModel->deleteLater();
        m_accountsModel = 0;
    }

    m_accountsModel = model;
    emit accountsModelChanged();
}

void AccountsController::setTransactionsModel(SqlListModel *model)
{
    if (m_transactionsModel)
    {
        m_transactionsModel->deleteLater();
        m_transactionsModel = 0;
    }

    m_transactionsModel = model;
    emit transactionsModelChanged();
}
