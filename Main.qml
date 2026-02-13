import QtQuick
import "qml/components"
import QtQuick.Controls 2.15
import com.Roboticus.ControlCenter
//TODO: note to self, column.selectedSensor/onClicked is unused, possible to use for something else? idk


Window {
    id: window
    visibility:  Window.Maximized
    minimumWidth: 854
    minimumHeight: 480
    title: qsTr("Roboticus Control Center")
    color: "#1a1a1a"
    property int vectorCounter: 0

    Material.theme: Material.Dark
    Material.accent: "#98FF98"


    SensorController {
        id: sensorController

        onSensorAdded: function(id, name, threshold, op, x, y) {
            sensorPanel.addPointToGraph(id, x, y)

        }

        onSensorRemoved: function(id) {
            sensorPanel.removePointFromGraph(id)
        }
    }

    VectorController {
        id: vectorController

        onVectorAdded: function(id, name, rotation, scale, color, x , y) {
            sensorPanel.addArrowToGraph(id, rotation, scale, color ,x,y)
        }

        onVectorRemoved: function(id) {
            sensorPanel.removeArrowFromGraph(id)
        }
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
        id: sensorPanel
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

            property var selection: null

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
                model: sensorController.model
                delegate: SensorInfo {
                    id: sensorDelegate
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 60

                    color: index % 2 === 0 ? "#1a1a1a" : "#151515"

                    sensorID: model.id
                    inputValue: model.inputValue
                    thresholdValue: model.threshold
                    selectedOperator: model.selectedOperator
                    xLocation: model.x
                    yLocation: model.y
                    selected: column.selection === sensorDelegate

                    onClicked: {
                        if(column.selection === sensorDelegate) {
                            column.selection = null;
                        } else {
                            column.selection = sensorDelegate;
                        }
                    }

                    onDeleteSensor: {
                        column.selection = null
                        sensorController.removeSensor(model.id)
                    }

                }
            }
        }

    }

    AddItem {
        id: addSensorButton
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 20
            bottomMargin: 20
        }
        height: 70
        width: (parent.width )/2

        onAddSensorRequested: sensorController.addSensor("name", 100, "==");
        onAddVectorRequested: vectorController.addVector("name", 0.0, 0.0);
    }


}
