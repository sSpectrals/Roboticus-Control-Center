import QtQuick
import "qml/components"
import QtQuick.Controls 2.15

Window {
    id: window
    visibility:  Window.Maximized
    visible: true
    title: qsTr("Roboticus Control Center")
    color: "grey"


    SensorPanel {

    }


    Column {
        id: column
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 3


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

}
