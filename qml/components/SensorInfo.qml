import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: sensorInfo
    property string sensorId: "No ID Set"
    property double inputValue: -1.0
    property double thresholdValue: 100.0
    property string selectedOperator: ">="

    color: "black"
    radius: 4
    border {
        width: 2
        color: mouseArea.containsMouse ? Material.color(Material.Green) : "#565656"
    }

    Behavior on border.color {
        ColorAnimation { duration: 150 }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: sensorInfo.forceActiveFocus();
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 2
        rows: 1

        // Column 1: Sensor ID
        Rectangle {
            Layout.preferredWidth: parent.width * 0.4
            Layout.fillHeight: true
            color: "transparent"

            TextField   {
                id: textInput
                color: "white"
                text: sensorId
                font.bold: true
                font.pixelSize: 14
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                selectByMouse: true
                selectionColor: "#4CAF50"
                selectedTextColor: "white"

                background: Rectangle {
                    color: "transparent"
                    border.color: textInput.hovered ? Material.color(Material.Green) : "transparent"
                    border.width: 2
                    radius: 4


                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }
                }

                onEditingFinished: {
                    sensorId = text
                    focus = false
                }
            }
        }

        // Column 2: input | operator | threshold
        Rectangle {
            Layout.preferredWidth: parent.width * 0.5
            Layout.fillHeight: true
            color: "#242424"
            radius: 10

            RowLayout {
                anchors.fill: parent
                spacing: 5


                // Input
                Rectangle{
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

                    Material.accent: Material.Green
                    Material.foreground: Material.Green


                    background: Rectangle {
                        color:  "#1a1a1a"
                        border.color: comboBox.hovered ? Material.color(Material.Green) : "transparent"
                        border.width: 2
                        radius: 4

                        // Optional: smooth transition
                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
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

                            ScrollIndicator.vertical: ScrollIndicator { }
                        }

                        background: Rectangle {
                            color: "#242424"
                            border.color: Material.color(Material.Green)
                            border.width: 2
                            radius: 4
                        }
                    }

                    delegate: ItemDelegate {
                            width: comboBox.width
                            hoverEnabled: true

                            contentItem: Text {
                                text: modelData
                                color: parent.highlighted || parent.hovered
                                       ? Material.color(Material.Green)
                                       : "#cccccc"
                            }

                            highlighted: comboBox.highlightedIndex === index

                            background: Rectangle {
                                color: parent.highlighted || parent.hovered
                                       ? "#1C1C1C"
                                       : "transparent"

                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }
                            }
                        }

                    onActivated: focus = false

                }


                // Threshold
                Rectangle{
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


    }
}
