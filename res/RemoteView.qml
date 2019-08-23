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
        delegate: ItemDelegate {
            id: remoteItem
            x: 5
            width: parent.width
            height: 40
            Row {
                id: row1
                anchors.margins: 5
                padding: 10
                spacing: 10
                Rectangle {
                    width: 35
                    height: 35
                    color: (url == "" ? "blue" : "green")
                }
                Column {
                    //width: parent.width - 80
                    height: 40
                    Text {
                        text: name
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
