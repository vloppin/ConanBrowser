import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant model: remoteList.model
    signal remoteSelected(int pValue)
    anchors.fill: parent

    title: qsTr("Remote List")

    ListView {
        id: remoteList
        anchors.fill: parent
        spacing: 2
        delegate: ItemDelegate {
            id: remoteItem
            x: 5
            y: 5
            width: parent.width-10
            height: 50
            background: Rectangle{
                border.width: 1
                border.color: "darkgrey"
                color: "lightgrey"
            }

            Row {
                id: row1
                padding: 5
                spacing: 10
                height: 40

                Rectangle {
                    width: 40
                    height: 40
                    color: (url == "" ? "blue" : "green")
                }
                Column {
                    height: 40
                    Text {
                        text: (name !== "" ? name : "Local-Cache")
                        font.bold: true
                    }
                    Text {
                        text: url
                    }
                }
            }
            onClicked: remoteSelected( index )
        }
        model: ListModel {
        }
    }
}
