import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant grid: gridPkg
    property variant model: gridRepeater.model
    property variant listModel: listPck.model
    property variant remoteName: remoteName
    property variant packageName: packageName
    property variant creationTime: creationTime

    anchors.fill: parent
    id: pckInfoPage


    padding: 10
    title: qsTr("Package Info")

    Column {
        spacing: 2

        Grid{
            id: headerInfo
            spacing: 5
            columns: 2
            Row{
                spacing: 5
                Text {
                    height: 20
                    width: 150
                    font.bold: true
                    text: qsTr("Package :")
                }
                Text {
                    id: packageName
                }
            }
            Row{
                spacing: 5
                Text {
                    height: 20
                    width: 150
                    font.bold: true
                    text: qsTr("Creation time :")
                }
                Text {
                    id: creationTime
                }
            }
            Row{
                spacing: 5
                Text {
                    height: 20
                    width: 150
                    font.bold: true
                    text: qsTr("Remote :")
                }
                Text {
                    id: remoteName
                }
            }
        }

        Rectangle{
            color: "black"
            height: 1
            width: pckInfoPage.width-24
        }

        Grid {
            id: gridPkg
            spacing: 2
            columns: 4


            Repeater {
                id: gridRepeater
                delegate:
                    Rectangle{
                        implicitWidth: 90
                        height: 30
                        width: (name != "" ? caseText.contentWidth + 10 : 30)
                        color: (outdated === 0 ? "white" : (outdated === 1 ? "darkyellow" : "darkgreen"))
                        Text{
                            id: caseText
                            leftPadding: 5
                            height: 25
                            fontSizeMode: Text.Fit
                            text: name
                        }
                    }
                model: ListModel {}
            }
        }

        Rectangle{
            color: "black"
            height: 1
            width: pckInfoPage.width-24
        }

        ListView {
            id: listPck
            spacing: 2
            height: 500
            width: pckInfoPage.width-24
            delegate:
                ItemDelegate {
                    width: pckInfoPage.width-24
                    height: 80
                    background: Rectangle{
                        border.width: 1
                        border.color: "darkgrey"
                        color: "lightgrey"
                    }

                    Row {
                        id: row1
                        padding: 5
                        spacing: 10
                        height: 60

                        Grid {
                            columns: 2
                            Text{
                                height: 20
                                width: 120
                                font.bold: true
                                text: qsTr("Compiler : ")
                            }
                            Text {
                                text: compiler
                                width: 500
                            }
                            Text {
                                height: 20
                                font.bold: true
                                text: qsTr("Build Type :")
                            }
                            Text {
                                text: build_type
                            }
                            Text {
                                height: 20
                                font.bold: true
                                text: qsTr("Options :")
                            }
                            Text {
                                text: optionString
                            }
                        }

                        Rectangle{
                            width: 70
                            height: 70
                            color: (outdated?"darkyellow":"darkgreen")
                        }
                }
            }
            model: ListModel {}
        } // ListView

        Rectangle{
            color: "black"
            height: 1
            width: pckInfoPage.width-24
        }

    } // Column
}
