import QtQuick
import "qml/components"
import QtQuick.Controls 2.15

Window {
    id: window
    visibility:  Window.Maximized
    title: qsTr("Roboticus Control Center")
    color: "#1a1a1a"
    property int sensorCounter: 0

    Material.theme: Material.Dark
    Material.accent: "#98FF98"


    ListModel {
        id: sensorModel
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a1a" }
            GradientStop { position: 1.0; color: "#0f0f0f" }
        }
        opacity: 0.8
    }

    SensorPanel {

    }

    Flickable {
        id: flickable
        anchors {
            left: parent.left
            top: parent.top
            bottom: addSensorButton.top
            bottomMargin: 20
            leftMargin: 20
            rightMargin: 20
        }
        width: parent.width /2
        flickableDirection: Flickable.VerticalFlick
        contentWidth: parent.width /2
        contentHeight: column.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds


        ScrollBar.vertical: ScrollBar {
            id: verticalScrollBar
            policy: ScrollBar.AsNeeded
            width: 8
            visible: flickable.contentHeight > flickable.height

            contentItem: Rectangle {
                implicitWidth: 6
                radius: 3
                color: verticalScrollBar.pressed ? "#22FF98" : "#98FF98"
                opacity: verticalScrollBar.active ? 0.8 : 0.4
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: 12

            property var selectedSensor: null
            property int selectedSensorIndex: -1

            Rectangle {
                width: parent.width
                height: 50
                color: "transparent"


                Text {
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

                Rectangle {
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

            Repeater {
                model: sensorModel
                delegate: SensorInfo {
                    id: sensorDelegate
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 60

                    color: index % 2 === 0 ? "#1a1a1a" : "#151515"

                    sensorId: model.sensorId
                    inputValue: model.inputValue
                    thresholdValue: model.thresholdValue
                    selectedOperator: model.selectedOperator
                    selected: column.selectedSensor === sensorDelegate

                    onClicked: {
                        if (column.selectedSensor === sensorDelegate) {
                            column.selectedSensor = null;
                            column.selectedSensorIndex = -1;
                        } else {
                            column.selectedSensor = sensorDelegate;
                            column.selectedSensorIndex = index;
                        }
                    }

                }
            }
        }

    }

    AddSensor {
        id: addSensorButton
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 20
            bottomMargin: 20
        }
        height: 70
        width: (parent.width )/2

        onAddClicked: addSensor()
        onRemoveClicked: removeSensor()
    }



    function addSensor() {
        sensorCounter++;
        sensorModel.append({
            "sensorId": "Sensor " + sensorCounter,
            "inputValue": 0.0,
            "thresholdValue": 100.0,
            "selectedOperator": ">="
        })
    }

    function removeSensor() {
        if (sensorModel.count > 0) {

            if (column.selectedSensorIndex !== -1) {
                sensorModel.remove(column.selectedSensorIndex);
                column.selectedSensor = null;
                column.selectedSensorIndex = -1;
            } else {
                // no sensor selected
                // sensorModel.remove(sensorModel.count - 1);
            }

        }
    }
}
