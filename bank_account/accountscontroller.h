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
};

#endif // ACCOUNTSCONTROLLER_H
