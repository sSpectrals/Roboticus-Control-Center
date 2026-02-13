import QtQuick
import QtGraphs

ScatterSeries {
    id: series

    property var sensorId: 0
    property real pointX: 0
    property real pointY: 0

    Component.onCompleted: {
        append(Qt.point(pointX, pointY));
    }

    pointDelegate: Rectangle {
        id: pointItem
        width: 15
        height: 15
        radius: width / 2
        color: "lime"

        DragHandler {
            id: dragHandler
            target: pointItem

            onActiveChanged: {
                if (!active) {
                    let centerPoint = pointItem.mapToItem(chart, pointItem.width / 2, pointItem.height / 2);

                    let newX = series.pixelToX(centerPoint.x);
                    let newY = series.pixelToY(centerPoint.y);

                    series.replace(0, newX, newY);
                }
            }
        }

        HoverHandler {
            cursorShape: dragHandler.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        }
    }

    function pixelToX(px) {
        let plotArea = chart.plotArea;
        let axisX = chart.axisX;
        return axisX.min + (px - plotArea.x) * (axisX.max - axisX.min) / plotArea.width;
    }

    function pixelToY(py) {
        let plotArea = chart.plotArea;
        let axisY = chart.axisY;
        return axisY.max - (py - plotArea.y) * (axisY.max - axisY.min) / plotArea.height;
    }
}
