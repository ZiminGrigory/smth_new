#pragma once

#include <QtCore/QObject>

class ListWrapper : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString color READ listColor)
public:
	explicit ListWrapper(QObject *parent = nullptr);
	ListWrapper(const QStringList &data, const QString &name, QObject *parent = nullptr);

	QString listColor() const;

	Q_INVOKABLE QStringList getList() const;

private:
	QStringList mList;
	QString mListColor;
};
