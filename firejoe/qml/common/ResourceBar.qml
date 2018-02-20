import VPlay 2.0
import QtQuick 2.0

Item {
    id: item

    property int barRotation: 180 // To allow both, vertical and horizontal direction
    property int countCurrent: 0
    property int countMax: 5
    property string borderColor: "gray"
    property Gradient resourceGradient: Gradient {
        GradientStop { position: 0.0; color: "#74ebd5" }
        GradientStop { position: 1.0; color: "#acb6e5" }
    }

    height: parent.height
    width: 80
    rotation: barRotation

    Column {
        // Repeat a bar multiple times
        Repeater {
            model: item.countCurrent
            Rectangle {
                width: item.width; height: item.height / item.countMax
                radius: width * 0.1
                border.width: 1 ; border.color: item.borderColor
                gradient: item.resourceGradient
            }
        }
    }
}
