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
