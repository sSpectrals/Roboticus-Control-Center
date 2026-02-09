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

                // let newX = pixelToX(pointItem.x + pointItem.width / 2)
                // let newY = pixelToY(pointItem.y + pointItem.height / 2)

                let centerPoint = pointItem.mapToItem(chart,
                                                      pointItem.width / 2,
                                                      pointItem.height / 2)
                let newX = series.pixelToX(centerPoint.x)
                let newY = series.pixelToY(centerPoint.y)

                series.replace(0, newX, newY)
            }
        }
    }

    function pixelToX(px) {
        let plotArea = chart.plotArea
        let axisX = chart.axisX
        return axisX.min + (px - plotArea.x) * (axisX.max - axisX.min) / plotArea.width
    }

    function pixelToY(py) {
        let plotArea = chart.plotArea
        let axisY = chart.axisY
        return axisY.max - (py - plotArea.y) * (axisY.max - axisY.min) / plotArea.height
    }
}
