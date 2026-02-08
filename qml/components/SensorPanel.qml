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

        ScatterSeries  {
            id: scatter

            XYPoint { x: 0.0; y: -7.0;}
            XYPoint { x: 1.0; y: -6.0;}

            pointDelegate: Rectangle {
                id: pointItem
                width: 15
                height: 15
                radius: width /2
                color: "lime"

                property real originalX: 0
                property real originalY: 0


                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.OpenHandCursor
                    drag.target: pointItem
                    drag.smoothed: false
                    drag.minimumX: -pointItem.width / 2
                    drag.maximumX: chart.width*0.96 - pointItem.width
                    drag.minimumY: -pointItem.height / 2
                    drag.maximumY: chart.height*0.96 - pointItem.height



                    onPressed: function(mouse) {
                        cursorShape = Qt.ClosedHandCursor
                        pointItem.originalX = chart.pixelToX(pointItem.x + pointItem.width / 2)
                        pointItem.originalY = chart.pixelToY(pointItem.y + pointItem.height / 2)
                    }

                    onReleased: function(mouse) {
                        cursorShape = Qt.OpenHandCursor

                        const newX = chart.pixelToX(pointItem.x + pointItem.width / 2)
                        const newY = chart.pixelToY(pointItem.y + pointItem.height / 2)

                        scatter.replace(pointItem.originalX, pointItem.originalY, newX, newY)


                    }
                }
            }

        }
    }


}
