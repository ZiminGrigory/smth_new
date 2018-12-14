#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScopedPointer>
#include <QtRemoteObjects/QRemoteObjectNode>
#include <QtRemoteObjects/QRemoteObjectHost>
#include <QtRemoteObjects>
#include <QObject>


#include "backend.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QScopedPointer<BackEnd> beObj(new BackEnd);

    QRemoteObjectHost nodeHost(QUrl(QStringLiteral("local:replica")),QUrl(QStringLiteral("local:registry")));
    QRemoteObjectRegistryHost nodeRegistry(QUrl(QStringLiteral("local:registry")));

    qDebug() << nodeRegistry.enableRemoting(beObj.data(), "MyTestHost");


    qmlRegisterType<BackEnd>("io.qt.examples.backend", 1, 0, "BackEnd");
    QQmlApplicationEngine engine;
    QQmlContext *lrc = engine.rootContext();
    lrc->setContextProperty("insertedBackEnd", beObj.data());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
