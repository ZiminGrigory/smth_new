#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>

#include <QTimer>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)

public:
    explicit BackEnd(QObject *parent = nullptr);
    ~BackEnd();

    QString userName();
Q_INVOKABLE void setUserName(const QString &userName);

signals:
    void userNameChanged();

private:
    QString m_userName = "asdasdasdasdas";

    QTimer *mTimer;
};

#endif // BACKEND_H
