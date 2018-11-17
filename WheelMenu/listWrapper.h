#pragma once

#include <QtCore/QObject>

class ListWrapper : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ listName WRITE setListName)
public:
	explicit ListWrapper(QObject *parent = nullptr);
	ListWrapper(const QStringList &data, const QString &name, QObject *parent = nullptr);

	QString listName() const;
	void setListName(const QString &name);

	Q_INVOKABLE QStringList getList() const;

private:
	QStringList mList;
	QString mListName;
};
