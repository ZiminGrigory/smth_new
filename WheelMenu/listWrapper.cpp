#include "listWrapper.h"

ListWrapper::ListWrapper(QObject *parent)
	: QObject(parent)
	, mCurrentItem(0)
{
}

ListWrapper::ListWrapper(const QStringList &data, const QString &name, QObject *parent)
	: QObject(parent)
	, mList(data)
	, mListColor(name)
	, mCurrentItem(0)
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

int ListWrapper::currentItem() const
{
	return mCurrentItem;
}

void ListWrapper::selectItem(int i)
{
	if (i < mList.length()) {
		mCurrentItem = i;
		emit currentItemChanged();
	}
}
