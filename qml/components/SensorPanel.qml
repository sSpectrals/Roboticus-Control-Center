import QtQuick
import QtGraphs

Rectangle {
    id: sensorPanel
    width: parent.width /2
    height: flickable.height
    color: "#1a1a1a"
    radius: 15
    border.width: 2
    border.color: "#98FF98"
    anchors {
        left: flickable.right
        top: parent.top
        right: parent.right
        margins: 20
    }

    signal pointMoved(real newX, real newY, int id)

    GraphsView {
        id: chart
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        axisX: axisX
        axisY: axisY

        theme: GraphsTheme {
            labelBorderVisible: false
            grid {
                mainColor: "grey"
                mainWidth: 2
            }
            gridVisible: true
        }

        ValueAxis {
            id: axisX
            min: -20
            max: 20
            visible: false
            labelsVisible: false
        }

        ValueAxis {
            id: axisY
            min: -20
            max: 20
            visible: false
            labelsVisible: false
        }

        function pixelToX(px) {
            return axisX.min + (px / width) * (axisX.max - axisX.min)
        }

        function pixelToY(py) {
            return axisY.max - (py / height) * (axisY.max - axisY.min)
        }
    }


    property var seriesMap: ({})

    function addPointToGraph(x, y, id) {
        // Create a new ScatterSeries for this point
        var component = Qt.createComponent("SinglePointSeries.qml")
        if (component.status === Component.Ready) {
            var series = component.createObject(chart, {
                "sensorId": id,
                "pointX": x,
                "pointY": y
            })

            chart.addSeries(series)
            seriesMap[id] = series
        }
    }

    function removePointFromGraph(id) {
        var series = seriesMap[id]
        if (series) {
            chart.removeSeries(series)

            delete seriesMap[id]

            series.destroy(100)

        }
    }

}
