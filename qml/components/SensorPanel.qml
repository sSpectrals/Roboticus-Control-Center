import QtQuick

Rectangle {
    id: sensorPanel
    width: parent.width /2
    color: "#1a1a2e"
    radius: 15
    border.width: 2
    border.color: "#2d3047"

    anchors {
        left: flickable.right
        top: parent.top
        bottom: parent.bottom
        right: parent.right
        margins: 20
    }

    Text {
        text: "GRID"
        font.family: "Segoe UI"
        font.pixelSize: 20
        font.weight: Font.DemiBold
        color: "#ffffff"
        opacity: 0.3
        anchors.centerIn: parent
    }
}
