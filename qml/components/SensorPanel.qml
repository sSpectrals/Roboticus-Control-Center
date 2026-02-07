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
        right: parent.right
        margins: 20
    }

    height: chart.height



    ChartView {
        id: chart
        anchors {
            left: parent.left
            right: parent.right
        }

        height: chart.width

        dropShadowEnabled: true
        antialiasing: true
        backgroundColor: "transparent"
        legend.visible: false

        ValueAxis {
            id: axisX
            min: -10
            max: 10
            tickCount: 20
            labelsColor: "white"
            gridLineColor: "#333333"
            lineVisible: false
            labelsVisible: false
        }

        ValueAxis {
            id: axisY
            min: -10
            max: 10
            tickCount: 20
            labelsColor: "white"
            gridLineColor: "#333333"
            lineVisible: false
            labelsVisible: false
        }

        ScatterSeries  {
            id: scatter1
            axisX: axisX
            axisY: axisY

            XYPoint { x: 0.0; y: -7.0 }
                XYPoint { x: 1.37; y: -6.87 }
                XYPoint { x: 2.67; y: -6.5 }
                XYPoint { x: 3.83; y: -5.9 }
                XYPoint { x: 4.83; y: -5.09 }
                XYPoint { x: 5.63; y: -4.1 }
                XYPoint { x: 6.18; y: -2.95 }
                XYPoint { x: 6.56; y: -1.65 }
                XYPoint { x: 6.73; y: 0.0 }
                XYPoint { x: 6.56; y: 1.65 }
                XYPoint { x: 6.18; y: 2.95 }
                XYPoint { x: 5.63; y: 4.1 }
                XYPoint { x: 4.83; y: 5.09 }
                XYPoint { x: 3.83; y: 5.9 }
                XYPoint { x: 2.67; y: 6.5 }
                XYPoint { x: 1.37; y: 6.87 }
                XYPoint { x: 0.0; y: 7.0 }
                XYPoint { x: -1.37; y: 6.87 }
                XYPoint { x: -2.67; y: 6.5 }
                XYPoint { x: -3.83; y: 5.9 }
                XYPoint { x: -4.83; y: 5.09 }
                XYPoint { x: -5.63; y: 4.1 }
                XYPoint { x: -6.18; y: 2.95 }
                XYPoint { x: -6.56; y: 1.65 }
                XYPoint { x: -6.73; y: 0.0 }
                XYPoint { x: -6.56; y: -1.65 }
                XYPoint { x: -6.18; y: -2.95 }
                XYPoint { x: -5.63; y: -4.1 }
                XYPoint { x: -4.83; y: -5.09 }
                XYPoint { x: -3.83; y: -5.9 }
                XYPoint { x: -2.67; y: -6.5 }
                XYPoint { x: -1.37; y: -6.87 }
        }
    }


}
