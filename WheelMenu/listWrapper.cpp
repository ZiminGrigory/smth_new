#include "listWrapper.h"

ListWrapper::ListWrapper(QObject *parent)
	: QObject(parent)
{
}

ListWrapper::ListWrapper(const QStringList &data, const QString &name, QObject *parent)
	: QObject(parent)
	, mList(data)
	, mListColor(name)
{
}

QString ListWrapper::listColor() const
{
	return mListColor;
}

QStringList ListWrapper::getList() const
{
	return mList;
}
