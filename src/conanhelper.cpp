#include "conanhelper.h"

#include <QDir>

#include <QtConcurrent/QtConcurrentRun>
#include <QFutureWatcher>

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include <QJSEngine>
#include <QJSValue>

#include <QProcess>

#include <iostream>

namespace  {

QByteArray getRemoteList()
{
	QStringList args = { "remote", "list" };
	QProcess lProcess;
	lProcess.start("conan", args);
	lProcess.waitForFinished();

	QByteArray lRawData = lProcess.readAll();


	QJsonDocument lDoc;
	QJsonArray lRemoteArray;

	QList<QByteArray> lRemotes = lRawData.split('\n');
	for(auto & lRemoteRaw : lRemotes )
	{
		QList<QByteArray> lRemotePart = lRemoteRaw.split(' ');
		if( lRemotePart.size() >= 2 )
		{
			QByteArray lRemoteName = lRemotePart.at(0);
			lRemoteName = lRemoteName.replace(":","");
			QByteArray lRemoteAddress = lRemotePart.at(1);

			QJsonObject lObj;
			lObj["name"] = QJsonValue( lRemoteName.toStdString().c_str() );
			lObj["url"] = QJsonValue( lRemoteAddress.toStdString().c_str() );

			lRemoteArray.append( lObj );
		}
	}
	lDoc.setArray(lRemoteArray);
	return lDoc.toJson();
}

QByteArray getJsonResult(QStringList & pArgs)
{
	QString lTmPath = QDir::tempPath();
	lTmPath += "/conan_package_result.json";

	pArgs << QString("-j=%1").arg(lTmPath);

	QProcess lProcess;
	lProcess.start("conan", pArgs);
	lProcess.waitForFinished(-1);

	QFile lFile;
	lFile.setFileName(lTmPath);
	lFile.open(QIODevice::ReadOnly);
	QByteArray lRes = lFile.readAll();
	lFile.close();

	QFile::remove(lTmPath);

	if( lProcess.exitCode() != 0){
		QByteArray lConsole = lProcess.readAll();
		std::cout << lConsole.data() << std::endl;
	}

	return lRes;
}

QByteArray getPackageList(const QString & pServer)
{
	QStringList args = { "search", "*" };
	if( ! pServer.isEmpty() ) args << QString("-r=%1").arg( pServer );

	return getJsonResult( args );
}

QByteArray getPackageInfo(const QString & pPackageName, const QString & pServer)
{
	QStringList args = { "info", pPackageName };
	if( ! pServer.isEmpty() ) args << QString("-r=%1").arg( pServer );

	return getJsonResult( args );
}

QByteArray getPackageMatrix(const QString & pPackageName, const QString & pServer)
{
	QStringList args = { "search", pPackageName };
	if( ! pServer.isEmpty() ) args << QString("-r=%1").arg( pServer );

	return getJsonResult( args );
}

QFutureWatcher<QByteArray> * getByteArrayWatcher(ConanHelper * pObj, const QJSValue & pCallback)
{
	auto *watcher = new QFutureWatcher<QByteArray>();
	QObject::connect(watcher, &QFutureWatcher<QByteArray>::finished,
						pObj, [pObj,watcher,pCallback]() {
		   QByteArray files = watcher->result();
		   QJSValue cbCopy(pCallback); // needed as callback is captured as const
		   QJSEngine *engine = qjsEngine(pObj);
		   cbCopy.call(QJSValueList { engine->toScriptValue(files) });
		   watcher->deleteLater();
	   });
	return watcher;
}

}

void ConanHelper::getRemoteList( const QJSValue & pCallback )
{
	auto * watcher = ::getByteArrayWatcher(this, pCallback);
	watcher->setFuture(QtConcurrent::run(&::getRemoteList));
}

void ConanHelper::getPackageList(const QString &pServer, const QJSValue &pCallback)
{
	auto * watcher = ::getByteArrayWatcher(this, pCallback);
	watcher->setFuture(QtConcurrent::run(&::getPackageList, pServer));
}

void ConanHelper::getPackageInfo(const QString &pPackageName, const QString &pServer, const QJSValue &pCallback)
{
	auto * watcher = ::getByteArrayWatcher(this, pCallback);
	watcher->setFuture(QtConcurrent::run(&::getPackageInfo, pPackageName, pServer));
}

void ConanHelper::getPackageMatrix(const QString &pPackageName, const QString &pServer, const QJSValue &pCallback)
{
	auto * watcher = ::getByteArrayWatcher(this, pCallback);
	watcher->setFuture(QtConcurrent::run(&::getPackageMatrix, pPackageName, pServer));
}
