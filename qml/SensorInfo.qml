import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: sensorInfo
    property string sensorName: "No Name Set"
    property var sensorID: -1
    property double inputValue: -1.0
    property double thresholdValue: 100.0
    property string selectedOperator: ">="
    property real xLocation: 0
    property real yLocation: 0
    property bool selected: false

    signal clicked
    signal deleteSensor

    color: "black"
    radius: 10
    border {
        width: 2
        color: (hoverHandler.hovered || selected) ? "#98FF98" : "#333333"
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 150
        }
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    // property bool triggered
    // switch(selectedOperator) {
    //     case ">=": triggered: inputValue >= thresholdValue ? true : false
    // }

    // TODO: change color depending on triggered or not?
    Rectangle {
        width: 6
        height: parent.height * 0.6
        color: "white"
        radius: 3
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 8
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 3
        rows: 1

        // Column 1: Sensor Name
        Rectangle {
            Layout.preferredWidth: parent.width * 0.4
            Layout.fillHeight: true
            color: "transparent"

            TextField {
                id: textInput
                color: "white"
                text: sensorName
                font.bold: true
                font.pixelSize: 14
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                selectByMouse: true
                selectionColor: "#98FF98"
                selectedTextColor: "#1a1a1a"
                hoverEnabled: true

                background: Rectangle {
                    color: "transparent"
                    border.color: textInput.hovered ? "#98FF98" : "transparent"
                    border.width: 2
                    radius: 4

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                onActiveFocusChanged: {
                    if (!activeFocus) {
                        // Lost focus
                        if (text.trim() === "") {
                            text = sensorName
                        } else {
                            sensorName = text
                        }
                    }
                }
            }
        }

        // Column 2: input | operator | threshold
        Rectangle {
            Layout.preferredWidth: parent.width * 0.5
            Layout.fillHeight: true
            color: "#1a1a1a"
            radius: 10

            RowLayout {
                anchors.fill: parent
                spacing: 5

                // Input
                Rectangle {
                    Layout.preferredWidth: 20
                    Layout.fillHeight: true
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: inputValue
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // Operator selection
                ComboBox {
                    id: comboBox
                    Layout.preferredWidth: 104
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    model: [">=", ">", "<", "<=", "==", "!=="]

                    Material.accent: "#98FF98"
                    Material.foreground: "#98FF98"

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
                            color: parent.highlighted
                                   || parent.hovered ? "#98FF98" : "#888888"
                        }

                        highlighted: comboBox.highlightedIndex === index

                        background: Rectangle {
                            color: parent.highlighted
                                   || parent.hovered ? "#0f0f0f" : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }
                        }
                    }

                    onActivated: focus = false
                }

                // Threshold
                Rectangle {
                    Layout.preferredWidth: 20
                    Layout.fillHeight: true
                    color: "transparent"
                    Layout.fillWidth: true
                    Text {
                        anchors.centerIn: parent
                        text: thresholdValue
                        font.pixelSize: 14
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Material.color(Material.Red)
            radius: 10
            Image {
                source: "./assets/SVG/trash.svg"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    deleteSensor()
                }
            }
        }
    }
}
