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

signals:
    void accountsUpdatedSignal();
    void transactionsUpdatedSignal();

private slots:
    void importQif(const int &idAccount, const QString &fileUrl);
    void create_account(const QString &name, const QString &number);
    void create_transaction(const int &idAccount, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
    void create_split_transaction(const int &idAccount, const int &idTransaction, const QDateTime &date, const QString &payee, const QString &memo, const QString &amount);
};

#endif // ACCOUNTSWORKER_H
