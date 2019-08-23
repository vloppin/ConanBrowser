import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant model: packageList.model
    signal packageSelected(int pValue)
    anchors.fill: parent

    title: qsTr("Package List")

    ListView {
        id: packageList
        anchors.fill: parent
        delegate: ItemDelegate {
            id: packageListItem
            x: 5
            width: parent.width
            height: 40
            Row {
                id: row1
                anchors.margins: 5
                padding: 10
                spacing: 10
                height: 30

                Text {
                    text: name
                    font.bold: true
                }
            }
            onClicked: packageSelected( index )
        }
        model: ListModel {
        }
    }
}
