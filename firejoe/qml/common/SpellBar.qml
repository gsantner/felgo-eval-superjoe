import VPlay 2.0
import QtQuick 2.0

Rectangle {
    id: itemBar

    property int barHeight: 52
    property int barZ: 1

    z: barZ
    height: barHeight
    anchors.left: parent.left ; anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 12
    radius: barHeight / 3 // Make corner radius dependent on height

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#111111" }
        GradientStop { position: 0.7; color: "#434341" }
        GradientStop { position: 1.0; color: "#4C4743" }
    }
}
