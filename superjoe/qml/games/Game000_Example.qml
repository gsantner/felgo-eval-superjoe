import QtQuick 2.0
import VPlay 2.0
import QtQuick.Layouts 1.2
import "../common" as Common
import "../entities" as Entities

Common.GameBase {
    id: game
    gameName: "Example"
    gameBackgroundOverlay: "ASSETIMG/fg1.png"
    gameDuration: 5

    // A simple element which will increase score upon click
    Rectangle {
        anchors.centerIn: parent
        width: 100
        height: 80
        color: "red"

        MouseArea {
            enabled: gameRunning
            anchors.fill: parent
            onPressed: increaseScore(1)
        }
    }

    // A simple element which will finish the game
    Rectangle {
        x: 50 ; y: 50
        width: 80
        height: 80
        color: "blue"

        MouseArea {
            enabled: gameRunning
            anchors.fill: parent
            onPressed: gameOver()
        }
    }
}
