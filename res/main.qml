import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: "#00FF00"

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    //drawer.open()
                }
            }
        }

        Label {
            id: remoteList
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    ConanHelper {
        id: conanHelper
    }

    PackageInfo {
        id: packageInfo
    }

    PackageListView {
        id: packageListView
        onPackageSelected: {
            var lPkgName = packageListView.model.get(pValue).name;
            console.debug( "Package : " + lPkgName + " selected" );

            control.visible = true
            conanHelper.packageName = lPkgName

            stackView.push(packageInfo);

            conanHelper.populatePackageInfo( lPkgName, conanHelper.serveUrl, packageInfo );
        }
    }

    RemoteView {
        id: remoteView
        onRemoteSelected: {
            var lServer = remoteView.model.get(pValue);
            control.visible = true

            console.debug("Remote : " + lServer.name + " selected" );

            conanHelper.serverName = lServer.name;
            conanHelper.serveUrl = lServer.url;

            stackView.push(packageListView);

            conanHelper.populatePackageFromServer( lServer.name, packageListView.model );
        }
    }


    StackView {
        id: stackView
        initialItem: remoteView
        anchors.fill: parent
    }


    BusyIndicator {
        id: control
        anchors.centerIn: stackView.parent

        contentItem: Item {
            implicitWidth: 64
            implicitHeight: 64

            Item {
                id: item
                x: parent.width / 2 - 32
                y: parent.height / 2 - 32
                width: 64
                height: 64
                opacity: control.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: control.visible && control.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 8

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: "#21be2b"
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: 5
                                origin.y: 5
                            }
                        ]
                    }
                }
            }
        }
    }
*/

    ConanHelper {
        id: conanHelper
    }

    PackageInfo {
        id: packageInfo
    }

    PackageListView {
        id: packageListView
        onPackageSelected: {
            var lPkgName = packageListView.model.get(pValue).name;
            console.debug( "Package : " + lPkgName + " selected" );

            conanHelper.packageName = lPkgName

            stackView.push(packageInfo);

            conanHelper.populatePackageInfo( lPkgName, conanHelper.serveUrl, packageInfo );
        }
    }

    RemoteView {
        id: remoteView
        onRemoteSelected: {
            var lServer = remoteView.model.get(pValue);
            console.debug("Remote : " + lServer.name + " selected" );

            conanHelper.serverName = lServer.name;
            conanHelper.serveUrl = lServer.url;

            stackView.push(packageListView);

            conanHelper.populatePackageFromServer( lServer.name, packageListView.model );
        }
    }

    StackView {
        id: stackView
        initialItem: remoteView
        anchors.fill: parent
    }

    Component.onCompleted:
    {
        conanHelper.populateRemotes( remoteView.model )
    }

}
