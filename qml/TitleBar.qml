import QtQuick
import QtQuick.Controls 2.15
import com.Roboticus.ControlCenter

Rectangle {
    id: title
    width: monitor.width
    height: 50
    color: "transparent"

    required property var serialParser

    anchors {
        left: parent.left
        bottomMargin: 20
        leftMargin: 20
        rightMargin: 20
    }

    Text {
        id: titleText
        text: "SENSOR MONITORING"
        font.pixelSize: 20
        font.weight: Font.DemiBold
        color: "white"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
    }

    ComboBox {
        id: comboBox
        width: titleText.width
        height: parent.height * 0.6
        model: {
            var ports = serialParser.availablePorts();
            return ports.length > 0 ? ports : ["No COM Port found"];
        }

        Material.accent: "#98FF98"
        Material.foreground: "#98FF98"
        anchors {
            left: titleText.right
            // top: titleText.top
            verticalCenter: parent.verticalCenter
            // bottom: titleText.bottom
            leftMargin: 20
        }

        background: Rectangle {
            color: "#0f0f0f"
            border.color: comboBox.hovered ? "#98FF98" : "#333333"
            border.width: 2
            radius: 4

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }
            }
        }

        popup: Popup {
            y: comboBox.height
            width: comboBox.width
            height: implicitHeight
            padding: 3
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}
            }

            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#98FF98"
                border.width: 2
                radius: 4
            }
        }

        delegate: ItemDelegate {
            width: comboBox.width
            hoverEnabled: true

            contentItem: Text {
                text: modelData
                color: parent.highlighted || parent.hovered ? "#98FF98" : "#888888"
            }

            highlighted: comboBox.highlightedIndex === index

            background: Rectangle {
                color: parent.highlighted || parent.hovered ? "#0f0f0f" : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }
        }

        onActivated: focus = false
    }

    Rectangle {
        id: greenLine
        width: parent.width - 20
        height: 2
        color: "#98FF98"
        opacity: 0.6
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 10
        }
    }
}
