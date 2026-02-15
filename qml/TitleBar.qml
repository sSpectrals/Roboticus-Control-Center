import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts
import com.Roboticus.ControlCenter

Rectangle {
    id: title
    width: monitor.width
    height: 50
    color: "transparent"

    required property var serialParser

    anchors {
        left: parent.left
        bottomMargin: 20
        leftMargin: 20
        rightMargin: 20
    }

    RowLayout {
        id: contentRow
        width: parent.width - 20
        height: parent.height
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        spacing: 20

        Text {
            id: titleText
            text: "SENSOR MONITORING"
            font.pixelSize: {
                if (window.width > 1600) {
                    20
                } else if (window.width > 1200) {
                    15
                } else {
                    10
                }
            }
            font.weight: Font.DemiBold
            color: "white"
        }

        ComboBox {
            id: comSelection
            Layout.preferredWidth: 150
            Layout.preferredHeight: title.height * 0.6
            Layout.alignment: Qt.AlignVCenter
            model: serialParser.availablePortsList.length > 0 ? serialParser.availablePortsList : ["No COM Port found"]
            Layout.fillWidth: true

            Material.accent: "#98FF98"
            Material.foreground: "#98FF98"

            background: Rectangle {
                color: "#0f0f0f"
                border.color: comSelection.hovered ? "#98FF98" : "#333333"
                border.width: 2
                radius: 4

                Behavior on border.color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            popup: Popup {
                y: comSelection.height
                width: comSelection.width
                height: implicitHeight
                padding: 3
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: comSelection.popup.visible ? comSelection.delegateModel : null
                    currentIndex: comSelection.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator {}
                }

                background: Rectangle {
                    color: "#1a1a1a"
                    border.color: "#98FF98"
                    border.width: 2
                    radius: 4
                }
            }

            delegate: ItemDelegate {
                width: comSelection.width
                hoverEnabled: true

                contentItem: Text {
                    text: modelData
                    color: parent.highlighted
                           || parent.hovered ? "#98FF98" : "#888888"
                }

                highlighted: comSelection.highlightedIndex === index

                background: Rectangle {
                    color: parent.highlighted
                           || parent.hovered ? "#0f0f0f" : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }
            }

            onActivated: function (index) {
                serialParser.setComPort(model[index])
                focus = false
            }
        }

        ComboBox {
            id: baudSelection
            Layout.preferredWidth: 110
            Layout.preferredHeight: title.height * 0.6
            Layout.alignment: Qt.AlignVCenter
            model: [1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200]

            Material.accent: "#98FF98"
            Material.foreground: "#98FF98"
            Layout.fillWidth: true

            background: Rectangle {
                color: "#0f0f0f"
                border.color: baudSelection.hovered ? "#98FF98" : "#333333"
                border.width: 2
                radius: 4

                Behavior on border.color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            popup: Popup {
                y: baudSelection.height
                width: baudSelection.width
                height: implicitHeight
                padding: 3
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: baudSelection.popup.visible ? baudSelection.delegateModel : null
                    currentIndex: baudSelection.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator {}
                }

                background: Rectangle {
                    color: "#1a1a1a"
                    border.color: "#98FF98"
                    border.width: 2
                    radius: 4
                }
            }

            delegate: ItemDelegate {
                width: baudSelection.width
                hoverEnabled: true

                contentItem: Text {
                    text: modelData
                    color: parent.highlighted
                           || parent.hovered ? "#98FF98" : "#888888"
                }

                highlighted: baudSelection.highlightedIndex === index

                background: Rectangle {
                    color: parent.highlighted
                           || parent.hovered ? "#0f0f0f" : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }
            }

            onActivated: function (index) {
                serialParser.setBaudRate(model[index])
                focus = false
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    Rectangle {
        id: greenLine
        width: parent.width - 20
        height: 2
        color: "#98FF98"
        opacity: 0.6
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 10
        }
    }
}
