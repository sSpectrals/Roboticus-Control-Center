import QtQuick
import QtQuick.Controls 2.15
import com.Roboticus.ControlCenter

Flickable {
    id: flickable

    width: parent.width / 2
    flickableDirection: Flickable.VerticalFlick
    contentWidth: parent.width / 2
    contentHeight: column.height
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    required property var sensorController
    required property var vectorController

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
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: 12

        property var selection: null

        ListView {
            id: sensorList
            width: parent.width
            height: contentHeight
            interactive: false
            model: sensorController.model
            spacing: 0
            clip: true

            onCountChanged: {
                if (count > 0) {
                    positionViewAtEnd()
                }
            }

            header: Rectangle {
                width: parent.width
                height: 50
                color: "transparent"

                Text {
                    text: "Sensors"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    color: "white"
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                }
            }

            add: Transition {
                NumberAnimation {
                    properties: "x"
                    from: 300
                    duration: 300
                }
            }

            delegate: SensorInfo {
                id: sensorDelegate
                width: ListView.view.width
                height: 60

                color: index % 2 === 0 ? "#1a1a1a" : "#151515"

                sensorName: model.name
                sensorID: model.id
                inputValue: model.inputValue
                thresholdValue: model.threshold
                isTriggered: model.isTriggered
                xLocation: model.x // Dragging sensors won't update this value due to model not being updated, dragging will just be visual
                yLocation: model.y

                selected: column.selection === sensorDelegate

                onClicked: {
                    column.selection = column.selection === sensorDelegate ? null : sensorDelegate
                }

                onDeleteSensor: {
                    column.selection = null
                    sensorController.removeSensor(model.id)
                }
            }
        }

        ListView {
            id: vectorList
            width: parent.width
            height: contentHeight
            interactive: false
            model: vectorController.model
            spacing: 0
            clip: true

            onCountChanged: {
                if (count > 0) {
                    positionViewAtEnd()
                }
            }

            header: Rectangle {
                width: parent.width
                height: 50
                color: "transparent"

                Text {
                    text: "Vectors"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    color: "white"
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                }
            }

            add: Transition {
                NumberAnimation {
                    properties: "x"
                    from: 300
                    duration: 200
                }
            }

            delegate: VectorInfo {
                id: vectorDelegate
                width: ListView.view.width
                height: 60

                color: index % 2 === 0 ? "#1a1a1a" : "#151515"

                vectorName: model.name
                vectorID: model.id
                rotationValue: model.rotation
                vectorColor: model.color
                xLocation: model.x
                yLocation: model.y

                selected: column.selection === vectorDelegate

                onClicked: {
                    column.selection = column.selection === vectorDelegate ? null : vectorDelegate
                }

                onDeleteVector: {
                    column.selection = null
                    vectorController.removeVector(model.id)
                }
            }
        }
    }
}
