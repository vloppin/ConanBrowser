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

}

void ConanHelper::getRemoteList( const QJSValue & pCallback )
{
	auto *watcher = new QFutureWatcher<QByteArray>();
	QObject::connect(watcher, &QFutureWatcher<QByteArray>::finished,
						this, [this,watcher,pCallback]() {
		   QByteArray files = watcher->result();
		   QJSValue cbCopy(pCallback); // needed as callback is captured as const
		   QJSEngine *engine = qjsEngine(this);
		   cbCopy.call(QJSValueList { engine->toScriptValue(files) });
		   watcher->deleteLater();
	   });
	watcher->setFuture(QtConcurrent::run(&::getRemoteList));
}

namespace
{

QByteArray getPackageList(const QString & pServer)
{
	QStringList args = { "search", "*" };
	if( ! pServer.isEmpty() ) args << QString("-r=%1").arg( pServer );

	QString lTmPath = QDir::tempPath();
	lTmPath += "/conan_package_result.json";

	args << QString("-j=%1").arg(lTmPath);

	QProcess lProcess;
	lProcess.start("conan", args);
	lProcess.waitForFinished();

	QFile lFile;
	lFile.setFileName(lTmPath);
	lFile.open(QIODevice::ReadOnly);
	QByteArray lRes = lFile.readAll();
	lFile.close();

	QFile::remove(lTmPath);

	return lRes;
}


}

void ConanHelper::getPackageList(const QString &pServer, const QJSValue &pCallback)
{
	auto *watcher = new QFutureWatcher<QByteArray>();
	QObject::connect(watcher, &QFutureWatcher<QByteArray>::finished,
						this, [this,watcher,pCallback]() {
		   QByteArray files = watcher->result();
		   QJSValue cbCopy(pCallback); // needed as callback is captured as const
		   QJSEngine *engine = qjsEngine(this);
		   cbCopy.call(QJSValueList { engine->toScriptValue(files) });
		   watcher->deleteLater();
	   });
	watcher->setFuture(QtConcurrent::run(&::getPackageList, pServer));
}
