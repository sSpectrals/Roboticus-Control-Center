import QtQuick
import QtGraphs

ScatterSeries {
    id: series

    property int sensorId: 0
    property real pointX: 0
    property real pointY: 0

    Component.onCompleted: {
        append(Qt.point(pointX, pointY))
    }

    pointDelegate: Rectangle {
        id: pointItem
        width: 15
        height: 15
        radius: width / 2
        color: "lime"

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.OpenHandCursor
            drag.target: pointItem
            drag.smoothed: false

            onPressed: function(mouse) {
                cursorShape = Qt.ClosedHandCursor
            }

            onReleased: function(mouse) {
                cursorShape = Qt.OpenHandCursor

                let newX = chart.pixelToX(pointItem.x + pointItem.width / 2)
                let newY = chart.pixelToY(pointItem.y + pointItem.height / 2)


                series.replace(0, newX, newY)
            }
        }
    }
}
