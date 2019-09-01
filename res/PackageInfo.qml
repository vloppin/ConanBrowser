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
            anchors.margins: 5
            border.width: 1
            border.color: "darkgrey"
            color: "lightgrey"
            height: 50
            width: pckInfoPage.width-24
            Row{
                anchors.centerIn: parent
                spacing: 5
                padding: 5
                ToolButton{
                    background: Rectangle{
                        id: buttonFrame
                        border.width: 1
                        border.color: "darkgrey"
                        color: "lightgrey"
                    }
                    hoverEnabled: true
                    onHoveredChanged: hovered ? buttonFrame.color = "grey" : buttonFrame.color = "lightgrey"
                    padding: 5
                    text: "Grid"
                    height: 40
                    width: 75
                    onClicked: {
                        if( gridPkg.visible ){
                            gridPkg.visible = false
                            listPck.visible = true
                            this.text = "Grid"
                        }
                        else
                        {
                            listPck.visible = false
                            gridPkg.visible = true
                            this.text = "List"
                        }
                    }
                }
            }
        }

        Grid {
            id: gridPkg
            spacing: 2
            columns: 4
            visible: false

            Repeater {
                id: gridRepeater
                delegate:
                    Rectangle{
                        height: (name !== "" ? caseText.contentHeight + 10 : 30)
                        width: (name !== "" ? caseText.contentWidth + 10 : 150)
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
                                width: 400
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
    } // Column
}
