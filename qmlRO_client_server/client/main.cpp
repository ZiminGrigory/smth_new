#include <QCoreApplication>
#include <QRemoteObjectNode>
#include <QScopedPointer>
#include <QtDebug>
#include <QMetaObject>
#include <iostream>
#include <QTimer>
#include <QtConcurrent/QtConcurrent>


int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);


    QRemoteObjectNode repc(QUrl(QStringLiteral("local:registry")));
    QScopedPointer<QRemoteObjectDynamicReplica> dynamicReplica(repc.acquireDynamic("MyTestHost"));

    qDebug() << dynamicReplica.data()->state();
    qDebug() << dynamicReplica.data()->waitForSource(-1);
    qDebug() << dynamicReplica.data()->state();

    QString answer;
    QTextStream stream(stdin);

    QFuture<void> future = QtConcurrent::run([&]() {
        // Code in this block will run in another thread
        while (true) {
            std::cout << "Enter new name pls-----> ";
            answer = stream.readLine();
            std::cout << "Entered name is: " << answer.toStdString() << std::endl;
            qDebug() << dynamicReplica.data()->state();
            QMetaObject::invokeMethod(dynamicReplica.data(), "setUserName"
                    , Qt::QueuedConnection, Q_ARG(const QString &, answer));
            qDebug() << dynamicReplica.data()->state();
        }
    });


    return a.exec();
}
