import QtQuick
import "qml/components"
import QtQuick.Controls 2.15

Window {
    id: window
    visibility:  Window.Maximized
    title: qsTr("Roboticus Control Center")
    color: "#2f3662"


    ListModel {
        id: sensorModel
    }

    SensorPanel {

    }


    Column {
        id: column
        width: parent.width / 2
        spacing: 5

        Repeater {
            model: sensorModel
            SensorInfo {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60

                sensorId: model.sensorId
                inputValue: model.inputValue
                thresholdValue: model.thresholdValue
                selectedOperator: model.selectedOperator
            }
        }
    }

    AddSensor {
        id: addSensorButton
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 10
            bottomMargin: 10
        }
        height: 70
        width: (parent.width )/2 - anchors.leftMargin*2

        onAddClicked: addSensor()
        onRemoveClicked: removeSensor()
    }

    function addSensor() {
        var sensorCount = sensorModel.count + 1
        sensorModel.append({
            "sensorId": "Sensor " + sensorCount,
            "inputValue": 0.0,
            "thresholdValue": 100.0,
            "selectedOperator": ">="
        })
    }

    function removeSensor() {
        if (sensorModel.count > 0) {
            sensorModel.remove(sensorModel.count - 1)
        }
    }
}
