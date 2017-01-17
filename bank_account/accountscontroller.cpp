#include "accountscontroller.h"

AccountsController::AccountsController(QObject *parent):
    Controller(parent)
{
    CREATE_DATABASE("QSQLITE", "ACCOUNTS");
}

AccountsController::~AccountsController()
{

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

void AccountsController::create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount)
{
    if (setActivity("Create Transaction"))
        emit createTransactionSignal(idAccount, date, payee, memo, amount);
}
