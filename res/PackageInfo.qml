import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    property variant grid: gridPkg
    anchors.fill: parent

    title: qsTr("Package Info")

    Grid {
        id: gridPkg
    }
}
