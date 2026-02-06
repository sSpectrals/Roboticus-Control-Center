import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../assets"


Row {
    id: buttonRow
    spacing: 10

    property color addButtonColor: "#4CAF50"
    property color deleteButtonColor: "#F44336"
    property color textColor: "white"
    property color hoverEffectColor: "#000000"

    signal addClicked()
    signal removeClicked()



    Button {
        id: addButton
        width: (parent.width - buttonRow.spacing) /2
        height: parent.height

        Material.foreground: buttonRow.textColor
        Material.background: buttonRow.addButtonColor
        Material.roundedScale: Button.None
        Material.elevation: deleteButton.hovered ? 3 : 1



        Image {
            anchors.centerIn: parent
            source: "../assets/SVG/add.svg"
            fillMode: Image.PreserveAspectFit
        }

        background: Rectangle {
            anchors.fill: parent
            color: addButton.Material.background
            radius: 0
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
                color: "black"
                radius: parent.radius
                opacity: addButton.down ? 0.2 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }
        }


        ToolTip.text: "Add new sensor (Ctrl+N)"
        ToolTip.visible: hovered && ToolTip.text.length > 0
        ToolTip.delay: 500
        ToolTip.toolTip.y: parent.height + 10



        onClicked: {
            buttonRow.addClicked()
        }
    }

    Button {
        id: deleteButton
        width: (parent.width - buttonRow.spacing) /2
        height: parent.height


        Material.foreground: buttonRow.textColor
        Material.background: buttonRow.deleteButtonColor
        Material.roundedScale: Button.None
        Material.elevation: deleteButton.hovered ? 3 : 1


        Image {
            anchors.centerIn: parent
            source: "../assets/SVG/remove.svg"
            fillMode: Image.PreserveAspectFit
        }


        background: Rectangle {
            anchors.fill: parent
            color: deleteButton.Material.background
            radius: 0
            border.color: Qt.darker(deleteButton.Material.background, 1.2)
            border.width: 1

            // Hover glow effect
            Rectangle {
                anchors.fill: parent
                color: buttonRow.hoverEffectColor
                radius: parent.radius
                opacity: deleteButton.hovered ? 0.15 : 0
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }

            // Pressed effect
            Rectangle {
                anchors.fill: parent
                color: "black"
                radius: parent.radius
                opacity: deleteButton.down ? 0.2 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }
        }

        ToolTip.text: "Remove selected sensor (Ctrl+D)"
        ToolTip.visible: hovered && ToolTip.text.length > 0
        ToolTip.delay: 500
        ToolTip.toolTip.y: parent.height + 10



        onClicked: {
            buttonRow.removeClicked()
        }
    }

    Shortcut {
        sequence: "Ctrl+N"
        onActivated: buttonRow.addClicked()
    }

    Shortcut {
        sequence: "Ctrl+D"
        onActivated: buttonRow.removeClicked()
    }

}
