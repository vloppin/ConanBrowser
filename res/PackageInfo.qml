import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant grid: gridPkg
    property variant model: gridRepeater.model
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
                    height: 25
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
                        color: (outdated === 0 ? "white" : (outdated === 1 ? "darkyellow" : "darkgreen"))
                        Text{
                            leftPadding: 5
                            height: 25
                            fontSizeMode: Text.Fit
                            text: name
                        }
                    }
                model: ListModel {}
            }
        }
    }
}
