#include "myfile.h"

MyFile::MyFile(const QString &name, QObject *parent):
    QObject(parent),
    m_file(name, this),
    m_textstream(&m_file)
{

}

void MyFile::setCodecName(const QString &name)
{
    if (!name.isEmpty())
        m_textstream.setCodec(QTextCodec::codecForName(name.toUtf8()));
}

QString MyFile::readLine(qint64 maxSize)
{
    QString res;
    while (!m_textstream.atEnd() && (maxSize==0 || res.size()<maxSize))
    {
        QString c = m_textstream.read(1);
        res.append(c);
        if (c.contains("\n") || c.contains("\r"))
            break;
    }

    return res;
}
