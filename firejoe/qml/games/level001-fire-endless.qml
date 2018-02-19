import QtQuick 2.0
import VPlay 2.0
import "../common" as Common

Common.LevelBase {
    gameName: "Timed"
    gameBackgroundOverlay: "fg1.png"

    Rectangle {
        color: "red"
        width: 80
        height: 80
        radius: 40
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: increaseScore(1)
        }
    }
}
