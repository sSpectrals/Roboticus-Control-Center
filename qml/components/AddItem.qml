import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../assets"

Row {
    id: buttonRow
    spacing: 10
    property color addButtonColor: "#98FF98"
    property color vectorButtonColor: "#FF6B6B"
    property color textColor: "#1a1a1a"
    property color hoverEffectColor: "#ffffff"
    signal addSensorRequested()
    signal addVectorRequested()

    Button {
        id: addButton
        width: (buttonRow.width - buttonRow.spacing) /2
        height: buttonRow.height
        Material.foreground: buttonRow.textColor
        Material.background: buttonRow.addButtonColor
        Material.roundedScale: Button.None
        Material.elevation: addButton.hovered ? 3 : 1
        Image {
            anchors.centerIn: parent
            source: "../assets/SVG/add.svg"
            fillMode: Image.PreserveAspectFit
        }
        background: Rectangle {
            anchors.fill: parent
            color: addButton.Material.background
            radius: 12
            border.color: Qt.darker(addButton.Material.background, 1.2)
            border.width: 1
            // Hover glow effect
            Rectangle {
                anchors.fill: parent
                color: buttonRow.hoverEffectColor
                radius: parent.radius
                opacity: addButton.hovered ? 0.15 : 0
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
            // Pressed effect
            Rectangle {
                anchors.fill: parent
                color: "#1a1a1a"
                radius: parent.radius
                opacity: addButton.down ? 0.2 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }
        }
        ToolTip.text: "Add new sensor (Ctrl+1)"
        ToolTip.visible: hovered && ToolTip.text.length > 0
        ToolTip.delay: 500
        ToolTip.toolTip.y: parent.height + 10
        onClicked: {
            buttonRow.addSensorRequested()
        }
    }

    Button {
        id: vectorButton
        width: (buttonRow.width - buttonRow.spacing) /2
        height: buttonRow.height
        Material.foreground: buttonRow.textColor
        Material.background: buttonRow.vectorButtonColor
        Material.roundedScale: Button.None
        Material.elevation: vectorButton.hovered ? 3 : 1
        Image {
            anchors.centerIn: parent
            source: "../assets/SVG/remove.svg"
            fillMode: Image.PreserveAspectFit
        }
        background: Rectangle {
            anchors.fill: parent
            color: vectorButton.Material.background
            radius: 12
            border.color: Qt.darker(vectorButton.Material.background, 1.2)
            border.width: 1
            // Hover glow effect
            Rectangle {
                anchors.fill: parent
                color: buttonRow.hoverEffectColor
                radius: parent.radius
                opacity: vectorButton.hovered ? 0.15 : 0
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
            // Pressed effect
            Rectangle {
                anchors.fill: parent
                color: "#1a1a1a"
                radius: parent.radius
                opacity: vectorButton.down ? 0.2 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }
        }
        ToolTip.text: "Add Vector (Ctrl+2)"
        ToolTip.visible: hovered && ToolTip.text.length > 0
        ToolTip.delay: 500
        ToolTip.toolTip.y: parent.height + 10
        onClicked: {
            buttonRow.addVectorRequested()
        }
    }

    Shortcut {
        sequence: "Ctrl+1"
        onActivated: buttonRow.addSensorRequested()
    }

    Shortcut {
        sequence: "Ctrl+2"
        onActivated: buttonRow.addVectorRequested()
    }
}
