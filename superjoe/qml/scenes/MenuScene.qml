import QtQuick 2.0
import QtMultimedia 5.0
import Felgo 3.0
import "../common" // Relative import - All components inside the ../common folder get available

// A scene based on SceneBase
SceneBase {
    id: menuScene

    signal gameSelected(string game)    // Expose game selection
    signal difficulyToggled()           // Toggles the difficulty
    signal aboutSelected()              // Switch to about screen

    // Add background color - using a fire red gradient
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem   // Fill the whole game window
        gradient: Gradient {
            GradientStop { position: 0.5; color: "#cb2d3e" }
            GradientStop { position: 1.0; color: "#ef473a" }
        }
    }

    // Show Joe as a boy - or his grown up form
    AppImage {
        source: GameData.currentDifficulty == "child" ? "../../assets/img/joe-01.png" : "../../assets/img/joe-02.png"
        height: parent.height / 2
        fillMode: Image.PreserveAspectFit
        anchors.right: menuScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10 ; anchors.bottomMargin: -5
        anchors.bottom: menuScene.gameWindowAnchorItem.bottom
    }

    // Play sound when menu screen is open
    SoundEffect {
        muted: !menuScene.enabled
        source: Qt.resolvedUrl("../../assets/sound/nature_fire_big.wav")
        loops: SoundEffect.Infinite
        autoPlay: true
    }

    // Show the games title
    Rectangle {
        y: dp(32)
        width: parent.width ; height: textTitle.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: "darkgray"

        Text {
            id: textTitle
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 36
            color: "white"
            text: GameData.gameTitle
            font.bold: true
        }
    }

    // Show the menu
    Column {
        anchors.centerIn: parent
        spacing: 10

        // Sends Main the signal to start specified game
        MenuButton {
            width: parent.width
            text: "Play Example"
            onClicked: gameSelected("Game000_Example")
        }

        MenuButton {
            width: parent.width
            text: "Play Survival"
            onClicked: gameSelected("Game001_Fire_Survival")
        }

        MenuButton {
            width: parent.width
            text: "Play TimeAttack"
            onClicked: gameSelected("Game002_Fire_TimeAttack")
        }

        Row {
            spacing: 5

            // Allows to switch between the supported 2 difficulties
            MenuButton {
                text: GameData.currentDifficulty == "child" ? "Adult mode" : "Child mode"
                onClicked: difficulyToggled()
            }
            MenuButton {
                text: "About"
                onClicked: aboutSelected()
            }
        }
    }
}
