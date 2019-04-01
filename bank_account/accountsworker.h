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
    explicit AccountsWorker(QObject *parent = Q_NULLPTR);
};

#endif // ACCOUNTSWORKER_H
