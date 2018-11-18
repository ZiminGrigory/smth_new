#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtCore/QList>

#include "listWrapper.h"


int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QGuiApplication app(argc, argv);

	qmlRegisterType<ListWrapper>("org.myModels", 1, 0, "SimpleListModel");
	auto clean = [](const QList<QObject *> &model) {
		for (auto list : model) {
			delete list;
		}
	};

	// model building
	// As I know there is no way to pass QVector to qml, but QList<QObject *> is ok
	// It's also possible to create own wrappers for QVector (as a member in class deriving from QAbstractListModel)
	// But it's still not a vector
	// And we still need some "list" inherited from QObject ...
	QList<QObject*> model;

	auto colors = QStringList{"red", "orange", "yellow", "green", "lightblue", "blue", "purple"};
	model.reserve(7);
	for (int i = 0; i < 7; ++i) {
		model.append(new ListWrapper({"1", "2", "3", "4"}, colors[i]));
	}

	QQmlApplicationEngine engine;
	QQmlContext *ctxt = engine.rootContext();
	ctxt->setContextProperty("myModel", QVariant::fromValue(model));

	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
	if (engine.rootObjects().isEmpty()) {
		clean(model);
		return -1;
	}

	int ret = app.exec();
	clean(model);
	return ret;
}
