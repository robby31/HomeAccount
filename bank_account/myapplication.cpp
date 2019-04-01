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

    connect(this, SIGNAL(mainQmlLoaded(QObject*)), this, SLOT(mainQmlLoaded(QObject*)));

    readSettings();

    // save settings to erase wrong Url
    saveSettings();
}

void MyApplication::mainQmlLoaded(QObject *obj)
{
    Q_UNUSED(obj)

    setdatabaseDiverName("QSQLITE");
    setdatabaseConnectionName("ACCOUNTS");
    connect(this, SIGNAL(databaseOpened(QString)), this, SLOT(databaseLoaded(QString)));
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
