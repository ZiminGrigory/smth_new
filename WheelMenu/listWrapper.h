#pragma once

#include <QtCore/QObject>

class ListWrapper : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString color READ listColor CONSTANT)
	Q_PROPERTY(int selectedItem READ currentItem WRITE selectItem NOTIFY currentItemChanged)
public:
	explicit ListWrapper(QObject *parent = nullptr);
	ListWrapper(const QStringList &data, const QString &name, QObject *parent = nullptr);

	QString listColor() const;
	Q_INVOKABLE QStringList getList() const;

	int currentItem() const;
	void selectItem(int i);

signals:
	void currentItemChanged();

private:
	QStringList mList;
	QString mListColor;
	int mCurrentItem;
};
