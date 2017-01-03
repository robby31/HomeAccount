#ifndef ACCOUNTSWORKER_H
#define ACCOUNTSWORKER_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include "mysqldatabase.h"
#include <QUrl>
#include <QDir>
#include "Worker/worker.h"
#include "../qif/qiffile.h"

class AccountsWorker : public Worker
{
    Q_OBJECT

public:
    explicit AccountsWorker(QObject *parent = 0);
    virtual ~AccountsWorker();

    void initializeWorker();

private:
    bool initializeDatabase();

signals:
    void initializeWorkerSignal();
    void databaseOpenedSignal(const QString &fileUrl);
    void databaseClosedSignal();
    void accountsUpdatedSignal();
    void transactionsUpdatedSignal();

private slots:
    void _initializeWorker();
    void loadDatabase(const QString &fileUrl);
    void closeDatabase();
    void importQif(const int &idAccount, const QString &fileUrl);
    void create_account(const QString &name, const QString &number);
    void create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
};

#endif // ACCOUNTSWORKER_H
