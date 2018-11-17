#include "listWrapper.h"

ListWrapper::ListWrapper(QObject *parent)
	: QObject(parent)
{
}

ListWrapper::ListWrapper(const QStringList &data, const QString &name, QObject *parent)
	: QObject(parent)
	, mList(data)
	, mListName(name)
{
}

QString ListWrapper::listName() const
{
	return mListName;
}

void ListWrapper::setListName(const QString &name)
{
	mListName = name;
}

QStringList ListWrapper::getList() const
{
	return mList;
}
