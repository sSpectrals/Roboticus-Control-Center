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
            // visible: false
            // labelsVisible: false
            zoom: 1.0
        }

        ValueAxis {
            id: axisY
            min: axisX.min
            max: axisX.max
            // visible: false
            // labelsVisible: false
            zoom: axisX.zoom
        }

        WheelHandler {
            target: chart
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

            onWheel: function(event) {
                let delta = event.angleDelta.y
                let zoomFactor = delta > 0 ? 1.1 : 0.9

                axisX.zoom *= zoomFactor

                axisX.zoom = Math.max(0.5, Math.min(4, axisX.zoom))


            }
        }

    }


    property var seriesMap: ({})

    function addPointToGraph(x, y, id) {

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

    function addArrowToGraph(x, y, rotation, scale, arrowColor ,id) {

        var component = Qt.createComponent("VectorArrow.qml")
        if (component.status === Component.Ready) {
            var series = component.createObject(chart, {
                "vectorId": id,
                "pointX": x,
                "pointY": y,
                "arrowRotation": rotation,
                "arrowScale": scale,
                "arrowColor": arrowColor
            })

            chart.addSeries(series)
            seriesMap[id] = series
        }
    }

    function removeArrowFromGraph(id) {
        var series = seriesMap[id]
        if (series) {
            chart.removeSeries(series)

            delete seriesMap[id]

            series.destroy(100)

        }
    }

}
