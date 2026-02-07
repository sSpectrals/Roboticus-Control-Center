import QtQuick
import QtCharts

Rectangle {
    id: sensorPanel
    width: parent.width /2
    color: "#1a1a1a"
    radius: 15
    border.width: 2
    border.color: "#98FF98"
    anchors {
        left: flickable.right
        top: parent.top
        bottom: parent.bottom
        right: parent.right
        margins: 20
    }



    ChartView {
        anchors.fill: parent
        antialiasing: true
        backgroundColor: "transparent"
        legend.visible: false


        ValueAxis {
            id: axisX
            min: 1.0
            max: 3.0
            tickCount: 5
            labelsColor: "white"
            gridLineColor: "#333333"
            lineVisible: false
            labelsVisible: false
        }

        ValueAxis {
            id: axisY
            min: 1.0
            max: 2.5
            tickCount: 5
            labelsColor: "white"
            gridLineColor: "#333333"
            lineVisible: false
            labelsVisible: false
        }

        ScatterSeries  {
            id: scatter1
            axisX: axisX
            axisY: axisY

            XYPoint { x: 1.5; y: 1.5 }
            XYPoint { x: 1.5; y: 1.6 }
            XYPoint { x: 1.57; y: 1.55 }
            XYPoint { x: 1.8; y: 1.8 }
            XYPoint { x: 1.9; y: 1.6 }
            XYPoint { x: 2.1; y: 1.3 }
            XYPoint { x: 2.5; y: 2.1 }
        }
    }


}
