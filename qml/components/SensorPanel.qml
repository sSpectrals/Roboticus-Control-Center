import QtQuick

Rectangle {
    id: sensorPanel
    width: parent.width /2
    color: "#1a1a1a"
    radius: 15
    border.width: 2
    border.color: "#98FF98"
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
        color: "#98FF98"
        opacity: 0.3
        anchors.centerIn: parent
    }
}
