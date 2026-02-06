import QtQuick
import "qml/components"
import QtQuick.Controls 2.15

Window {
    id: window
    visibility:  Window.Maximized
    title: qsTr("Roboticus Control Center")
    color: "#2f3662"


    SensorPanel {

    }


    Column {
        id: column
        width: parent.width / 2



        Repeater {
            model: 4
            SensorInfo {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60

                sensorId: "Sensor " + (index + 1)
                inputValue: [1023.99, 101.3 , 65, 12.3][index]
                thresholdValue: [1023.99, 120.0, 80, 12.0][index]
                selectedOperator: ["<", ">", "<=", ">="][index]
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
    }
}
