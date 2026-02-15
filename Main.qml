import QtQuick
import "qml"
import QtQuick.Controls 2.15
import com.Roboticus.ControlCenter

//TODO: note to self, column.selectedSensor/onClicked is unused, possible to use for something else? idk
Window {
    id: window
    visibility: Window.Maximized
    minimumWidth: 890
    minimumHeight: 480
    title: qsTr("Roboticus Control Center")
    color: "#1a1a1a"

    Material.theme: Material.Dark
    Material.accent: "#98FF98"

    SensorController {
        id: sensorController

        onSensorAdded: function (id, name, input, threshold, op, x, y) {
            sensorPanel.addPointToGraph(id, x, y)
        }

        onSensorRemoved: function (id) {
            sensorPanel.removePointFromGraph(id)
        }
    }

    VectorController {
        id: vectorController

        onVectorAdded: function (id, name, rotation, scale, color, x, y) {
            sensorPanel.addArrowToGraph(id, rotation, scale, color, x, y)
        }

        onVectorRemoved: function (id) {
            sensorPanel.removeArrowFromGraph(id)
        }
    }

    SerialParser {
        id: serialParser
        Component.onCompleted: setModels(sensorController.model,
                                         vectorController.model)
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#1a1a1a"
            }
            GradientStop {
                position: 1.0
                color: "#0f0f0f"
            }
        }
        opacity: 0.8
    }

    SensorPanel {
        id: sensorPanel
    }

    TitleBar {
        id: title

        serialParser: serialParser
    }

    MonitoringPanel {
        id: monitor

        anchors {
            left: parent.left
            top: title.bottom
            bottom: addSensorButton.top
            bottomMargin: 20
            leftMargin: 20
            rightMargin: 20
        }

        sensorController: sensorController
        vectorController: vectorController
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
        width: (parent.width) / 2

        onAddSensorRequested: sensorController.addSensor("Sensor name", 0, 100,
                                                         "==", 0.0, 0.0)
        onAddVectorRequested: vectorController.addVector("Vector name", 0.0, 1,
                                                         "white", 0.0, 0.0)
    }
}
