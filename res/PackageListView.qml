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
        spacing: 2
        delegate: ItemDelegate {
            id: packageListItem
            x: 5
            width: parent.width-10
            height: 40
            background: Rectangle{
                border.width: 1
                border.color: "darkgrey"
                color: "lightgrey"
            }
            onHoveredChanged: hovered ? background.color = "grey" : background.color = "lightgrey"
            Text {
                anchors.fill: parent
                leftPadding: 20
                verticalAlignment: Text.AlignVCenter
                text: name
                font.bold: true
            }
            onClicked: packageSelected( index )
        }
        model: ListModel {
        }
    }
}
