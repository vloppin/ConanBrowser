import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant model: packageList.model
    signal packageSelected(int pValue)
    anchors.fill: parent

    padding: 10
    title: qsTr("Package List")

    Column{
        spacing: 2
        anchors.fill: parent

        Rectangle{
            anchors.margins: 5
            border.width: 1
            border.color: "darkgrey"
            color: "lightgrey"
            height: 50
            width: parent.width-10
            TextInput {
                id: input
                y: 5
                x: 5
                height: 40
                width: parent.width-10
                focus: true
                cursorVisible: true
                selectByMouse: true
                //anchors { left: prefix.right; right: parent.right; top: parent.top; bottom: parent.bottom }
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                color: "#707070"
                text: "Search ..."
                //onAccepted: wrapper.accepted()
                //onTextChanged: packageList.model.
            }
        }

        ListView {
            id: packageList
            width: parent.width-10
            //anchors.fill: parent
            y: 65
            spacing: 2
            height: 500
            delegate: ItemDelegate {
                id: packageListItem
                //x: 5
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
}
