#include "myapplication.h"

MyApplication::MyApplication(int &argc, char **argv):
    Application(argc, argv),
    m_settings("HIMBERT", "HomeAccount"),
    m_accountsController(this),
    m_accountsWorker(0)
{
    addController("accountsController", &m_accountsController);

    m_accountsWorker = new AccountsWorker();
    addWorker(&m_accountsController, m_accountsWorker);
    m_accountsWorker->initializeWorker();

    connect(&m_accountsController, SIGNAL(loadingSignal(QString)), m_accountsWorker, SLOT(loadDatabase(QString)));
    connect(&m_accountsController, SIGNAL(closeSignal()), m_accountsWorker, SLOT(closeDatabase()));
    connect(&m_accountsController, SIGNAL(importQifSignal(int,QString)), m_accountsWorker, SLOT(importQif(int,QString)));
    connect(&m_accountsController, SIGNAL(createAccountSignal(QString, QString)), m_accountsWorker, SLOT(create_account(QString,QString)));
    connect(&m_accountsController, SIGNAL(createTransactionSignal(int,QDateTime,QString,QString,QString)), m_accountsWorker, SLOT(create_transaction(int,QDateTime,QString,QString,QString)));
    connect(m_accountsWorker, SIGNAL(databaseOpenedSignal(QString)), &m_accountsController, SLOT(databaseOpened(QString)));
    connect(m_accountsWorker, SIGNAL(databaseClosedSignal()), &m_accountsController, SIGNAL(databaseClosedSignal()));
    connect(m_accountsWorker, SIGNAL(accountsUpdatedSignal()), &m_accountsController, SIGNAL(accountsUpdatedSignal()));
    connect(m_accountsWorker, SIGNAL(transactionsUpdatedSignal()), &m_accountsController, SIGNAL(transactionsUpdatedSignal()));

    connect(this, SIGNAL(mainQmlLoaded(QObject*)), this, SLOT(mainQmlLoaded(QObject*)));

    readSettings();
}

void MyApplication::mainQmlLoaded(QObject *obj)
{
    connect(obj, SIGNAL(loadDatabase(QString)), &m_accountsController, SLOT(loadDatabase(QString)));
    connect(obj, SIGNAL(closeDatabase()), &m_accountsController, SLOT(closeDatabase()));
    connect(obj, SIGNAL(importQif(int,QString)), &m_accountsController, SLOT(importQif(int,QString)));
    connect(obj, SIGNAL(create_account(QString, QString)), &m_accountsController, SLOT(create_account(QString, QString)));
    connect(obj, SIGNAL(create_new_transaction(int,QDateTime,QString,QString,QString)), &m_accountsController, SLOT(create_transaction(int,QDateTime,QString,QString,QString)));

    connect(&m_accountsController, SIGNAL(databaseLoaded(QString)), this, SLOT(databaseLoaded(QString)));
    connect(&m_accountsController, SIGNAL(databaseLoaded(QString)), obj, SLOT(databaseLoaded()));
    connect(&m_accountsController, SIGNAL(databaseClosedSignal()), obj, SLOT(databaseClosed()));
    connect(&m_accountsController, SIGNAL(accountsUpdatedSignal()), obj, SLOT(reloadDatabase()));
    connect(&m_accountsController, SIGNAL(transactionsUpdatedSignal()), obj, SLOT(reloadDatabase()));
}

void MyApplication::readSettings()
{
    m_recentFiles.clear();

    int size = m_settings.beginReadArray("recentFiles");
    for (int i = 0; i < size; ++i) {
        m_settings.setArrayIndex(i);
        m_recentFiles << m_settings.value("url").toString();
    }
    m_settings.endArray();

    emit recentFilesChanged();
}

void MyApplication::databaseLoaded(const QString &fileUrl)
{
    if (!m_recentFiles.contains(fileUrl))
    {
        int size = m_settings.beginReadArray("recentFiles");
        m_settings.endArray();
        m_settings.beginWriteArray("recentFiles");
        m_settings.setArrayIndex(size);
        m_settings.setValue("url", fileUrl);
        m_settings.endArray();

        readSettings();
    }
}
