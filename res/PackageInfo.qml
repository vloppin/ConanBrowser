import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant grid: gridPkg
    property variant model: gridRepeater.model
    anchors.fill: parent

    title: qsTr("Package Info")

    Grid {
        id: gridPkg
        spacing: 2
        columns: 4
        anchors.fill: parent

        Repeater {
            id: gridRepeater
            delegate:
                Text{
                    width: 50
                    height: 50
                    text: name
                }

                /*
                Item{
                    Column{
                        Rectangle {
                            width: 50
                            height: 50
                            color: "red"
                        }
                        Rectangle {
                            width: 50
                            height: 50
                            color: "blue"
                        }
                    }
                }*/
            model: ListModel {}
        }
    }
}
