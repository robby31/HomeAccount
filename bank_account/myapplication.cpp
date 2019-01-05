#include "myapplication.h"

MyApplication::MyApplication(int &argc, char **argv):
    Application(argc, argv),
    m_settings("HIMBERT", "HomeAccount"),
    m_accountsController(this),
    m_accountsWorker(Q_NULLPTR)
{
    addController("accountsController", &m_accountsController);

    m_accountsWorker = new AccountsWorker();
    addWorker(&m_accountsController, m_accountsWorker);

    connect(&m_accountsController, SIGNAL(importQifSignal(int,QString)), m_accountsWorker, SLOT(importQif(int,QString)));
    connect(&m_accountsController, SIGNAL(createTransactionSignal(int,QDateTime,QString,QString,QString)), m_accountsWorker, SLOT(create_transaction(int,QDateTime,QString,QString,QString)));    
    connect(&m_accountsController, SIGNAL(createSplitTransactionSignal(int,int,QDateTime,QString,QString,QString)), m_accountsWorker, SLOT(create_split_transaction(int,int,QDateTime,QString,QString,QString)));
    connect(m_accountsWorker, SIGNAL(transactionsUpdatedSignal()), &m_accountsController, SIGNAL(transactionsUpdatedSignal()));

    connect(this, SIGNAL(mainQmlLoaded(QObject*)), this, SLOT(mainQmlLoaded(QObject*)));

    readSettings();

    // save settings to erase wrong Url
    saveSettings();
}

void MyApplication::mainQmlLoaded(QObject *obj)
{
    setdatabaseDiverName("QSQLITE");
    setdatabaseConnectionName("ACCOUNTS");
    connect(this, SIGNAL(databaseOpened(QString)), this, SLOT(databaseLoaded(QString)));

    connect(obj, SIGNAL(importQif(int,QString)), &m_accountsController, SLOT(importQif(int,QString)));
    connect(obj, SIGNAL(create_new_transaction(int,QDateTime,QString,QString,QString)), &m_accountsController, SLOT(create_transaction(int,QDateTime,QString,QString,QString)));
    connect(obj, SIGNAL(create_new_split_transaction(int,int,QDateTime,QString,QString,QString)), &m_accountsController, SLOT(create_split_transaction(int,int,QDateTime,QString,QString,QString)));

    connect(&m_accountsController, SIGNAL(transactionsUpdatedSignal()), obj, SLOT(reloadDatabase()));
}

QStringList MyApplication::recentFiles() const
{
    return m_recentFiles;
}

void MyApplication::readSettings()
{
    m_recentFiles.clear();

    int size = m_settings.beginReadArray("recentFiles");
    for (int i = 0; i < size; ++i) {
        m_settings.setArrayIndex(i);
        QUrl url(m_settings.value("url").toString());
        QFileInfo info(url.toLocalFile());
        if (url.isLocalFile() && info.exists())
            m_recentFiles << m_settings.value("url").toString();
        else
            qCritical() << "invalid url" << url;
    }
    m_settings.endArray();

    emit recentFilesChanged();
}

void MyApplication::saveSettings()
{
    m_settings.remove("recentFiles");
    int index = 0;
    foreach (QString url, m_recentFiles)
    {
        m_settings.beginWriteArray("recentFiles");
        m_settings.setArrayIndex(index);
        index++;
        m_settings.setValue("url", url);
        m_settings.endArray();
    }
}

void MyApplication::databaseLoaded(const QString &fileUrl)
{
    if (!m_accountsController.initializeDatabase())
    {
        qCritical() << "unable to initialize database" << fileUrl;
    }
    else
    {
        QString url = QUrl::fromLocalFile(fileUrl).toString();
        if (m_recentFiles.contains(url))
            m_recentFiles.move(m_recentFiles.indexOf(url), 0);
        else
            m_recentFiles.prepend(url);

        saveSettings();
        emit recentFilesChanged();
    }
}

void MyApplication::check_split_id(const int &transactionId)
{
    QSqlQuery query(GET_DATABASE("ACCOUNTS"));
    query.prepare("SELECT count(id) from transactions WHERE split_id=:split_id");
    query.bindValue(":split_id", transactionId);

    if (!query.exec())
    {
        qCritical() << "invalid query" << query.lastError().text();
    }
    else
    {
        if (query.next() && query.value(0).toInt() == 0)
        {
            // no more transaction related to transactionId
            // so transactionId is not split any more
            query.prepare("UPDATE transactions SET is_split=0 WHERE id=:id");
            query.bindValue(":id", transactionId);
            if (!query.exec())
                qCritical() << "unable to update transaction" << query.lastError().text();
        }
    }

}
