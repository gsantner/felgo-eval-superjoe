import QtQuick 2.0
import VPlay 2.0
import "../common" as Common

Common.GameBase {
    gameName: "Endless"
    gameBackgroundOverlay: "fg1.png"

    Rectangle {
        anchors.centerIn: parent
        width: 80 ; height: 80
        color: "red"
        radius: 40
        MouseArea {
            anchors.fill: parent
            onPressed: increaseScore(1)
        }
    }
}
