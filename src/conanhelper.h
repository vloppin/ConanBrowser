#ifndef CONANHELPER_H
#define CONANHELPER_H

#include <QObject>

class QJSValue;

class ConanHelper : public QObject
{
Q_OBJECT

public:
	Q_INVOKABLE void getRemoteList(const QJSValue & pCallback);

	Q_INVOKABLE void getPackageList(const QString & pServer, const QJSValue & pCallback);

	Q_INVOKABLE void getPackageInfo(const QString & pPackageName, const QString & pServer, const QJSValue & pCallback);

	Q_INVOKABLE void getPackageMatrix(const QString & pPackageName, const QString & pServer, const QJSValue & pCallback);
};

#endif // CONANHELPER_H
