#include "backend.h"

#include <QtDebug>


BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
    , mTimer(new QTimer(this))
{
    connect(mTimer, &QTimer::timeout, this, [](){
        qDebug() << "tick";
    });

    mTimer->start(3000);
    qDebug() << "Source Node Started";
}

BackEnd::~BackEnd()
{
    mTimer->stop();
}

QString BackEnd::userName()
{
    return m_userName;
}

void BackEnd::setUserName(const QString &userName)
{
    qDebug() << Q_FUNC_INFO;
    if (userName == m_userName)
        return;

    m_userName = userName;
    emit userNameChanged();
}
