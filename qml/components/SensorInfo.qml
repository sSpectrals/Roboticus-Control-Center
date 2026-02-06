import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: sensorInfo
    property string sensorId: "No ID Set"
    property double inputValue: -1.0
    property double thresholdValue: 100.0
    property string selectedOperator: ">="
    property bool isHovered: mouseArea.containsMouse



    color: "black"
    radius: 10
    border {
        width: 2
        color: isHovered ? "#cacaca" : "#565656"
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        rows: 1
        columnSpacing: 10
        rowSpacing: 10

        // Column 1: Sensor ID (50% width)
        Rectangle {
            Layout.preferredWidth: parent.width * 0.4
            Layout.fillHeight: true
            color: "transparent"

            Text {
                color: "white"
                text: sensorId
                font.bold: true
                font.pixelSize: 14
                anchors.centerIn: parent
            }
        }

        Rectangle {
            Layout.preferredWidth: parent.width * 0.5
            Layout.fillHeight: true
            color: "#242424"
            radius: 10

            RowLayout {
                anchors.fill: parent
                spacing: 5


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



                ComboBox {
                    id: comboBox
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.preferredWidth: 32
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    model: [">=", ">", "<", "<=", "==", "!=="]

                    delegate: ItemDelegate {
                        width: comboBox.width
                        contentItem: Text {
                            text: modelData
                            anchors.centerIn: parent
                            color: "white"
                            font: comboBox.font
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: comboBox.highlightedIndex === index
                    }

                    contentItem: Text {
                        color: "white"
                        text: comboBox.displayText
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                    }

                    background: Rectangle {
                        color: "#d7434343"
                        radius: 10
                        border.color: isHovered ? "#cacaca" : "#565656"
                        border.width: 2
                    }
                }

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
