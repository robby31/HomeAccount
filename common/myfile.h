#ifndef MYFILE_H
#define MYFILE_H

#include <QFile>
#include <QTextStream>
#include <QTextCodec>
#include <QDebug>

class MyFile : public QObject
{
public:
    MyFile(const QString &name, QObject *parent = Q_NULLPTR);

    void setCodecName(const QString &name);

    bool open()     { return m_file.open(QFile::ReadOnly); }
    void close()    { return m_file.close();    }

    QString readLine(qint64 maxSize = 0);
    QString readAll() { return m_textstream.readAll(); }

private:
    QFile m_file;
    QTextStream m_textstream;
};

#endif // MYFILE_H
