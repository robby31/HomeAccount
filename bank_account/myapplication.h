#ifndef MYAPPLICATION_H
#define MYAPPLICATION_H

#include <QDebug>
#include <QSettings>
#include "application.h"
#include "accountscontroller.h"
#include "accountsworker.h"

class MyApplication : public Application
{
    Q_OBJECT

    Q_PROPERTY(QStringList recentFiles READ recentFiles NOTIFY recentFilesChanged)

public:
    MyApplication(int &argc, char **argv);

    QStringList recentFiles() const;

private:
    void readSettings();
    void saveSettings();

signals:
    void recentFilesChanged();

public slots:
    void mainQmlLoaded(QObject *obj);
    void databaseLoaded(const QString &fileUrl);

    void check_split_id(const int &transactionId);

private:
    QSettings m_settings;
    AccountsController m_accountsController;
    AccountsWorker *m_accountsWorker;
    QStringList m_recentFiles;
};

#endif // MYAPPLICATION_H
