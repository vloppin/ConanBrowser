import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import ConanHelper 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: "#FF0000"

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
//                if (stackView.depth > 1) {
//                    stackView.pop()
//                } else {
//                    drawer.open()
//                }
            }
        }

        Label {
            id: remoteList
//            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

//    Drawer {
//        id: drawer
//        width: window.width * 0.66
//        height: window.height

//        Column {
//            anchors.fill: parent

//            ItemDelegate {
//                text: qsTr("Page 1")
//                width: parent.width
//                onClicked: {
//                    stackView.push("Page1Form.ui.qml")
//                    drawer.close()
//                }
//            }
//            ItemDelegate {
//                text: qsTr("Page 2")
//                width: parent.width
//                onClicked: {
//                    stackView.push("Page2Form.ui.qml")
//                    drawer.close()
//                }
//            }
//        }
//    }

    PackageModel {
        id: packageModel
    }
    Component {
        id: packageDelegate
        Item {
            width: 340; height: 40
            ItemDelegate {
                anchors.fill: parent
                Rectangle{
                    anchors.fill: parent
                    color: "#C0C0C0"
                    border.color: "black"
                    border.width: 1
                    Column {
                        Text { text: '<b>Name:</b> ' + name }
                    }
                }
            }
        }
    }

    ConanHelper{
        id: ch
    }

    Component {
        id: remoteDelegate
        Item {
            width: 340; height: 40
            ItemDelegate {
                anchors.fill: parent
                Rectangle{
                    anchors.fill: parent
                    color: "#C0C0C0"
                    border.color: "black"
                    border.width: 1
                    Column {
                        Text { text: '<b>Name:</b> ' + name }
                        Text { text: '<b>URL:</b> ' + url }
                    }
                }
                onDoubleClicked: {
                    mainListView.visible = false;
                    packageListView.visible = true;
                    packageModel.populate( "" );

                    /*
                    console.debug("> Package Listing : Start")
                    var lName  = name;
                    var lUrl = url;

                    //mainListView.delegate = packageDelegate
                    //mainListView.model = packageModel

                    ch.getPackageList(lUrl, function(pPackageList)
                    {
                        var packageList = JSON.parse(pPackageList);
                        var toto = packageList.results[0].items
                        for( var aaa in toto )
                        {
                            var pckName = toto[aaa].recipe.id
                            console.log(pckName)
                            packageModel.append({ "name": pckName })
                            console.log("CHOUCROUTE")
                        }

                        console.debug("> Package Listing : Done")
                    });


                    remoteList.text = lName
                    remoteModel.model.clear();
                    */
                }
            }
        }
    }

    RemoteModel{
        id: remoteModel
    }

    BusyIndicator {
        id: control

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

    ListView {
        id: mainListView
        anchors.fill: parent
        delegate: remoteDelegate
        model: remoteModel.model
    }

    ListView {
        id: packageListView
        anchors.fill: parent
        delegate: packageDelegate
        model: packageModel.model
        visible: false
    }
}
