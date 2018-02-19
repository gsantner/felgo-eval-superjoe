import VPlay 2.0
import QtQuick 2.0
import "../common"

// A scene based on SceneBase
SceneBase {
    id: menuScene

    signal gameSelected(string game)                // Expose game selection
    signal difficulyToggled()                       // Toggles the difficulty
    signal aboutSelected()

    // Add background color - using a fire red gradient
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem   // Fill the whole game window
        gradient: Gradient {
            GradientStop { position: 0.5; color: "#cb2d3e" }
            GradientStop { position: 1.0; color: "#ef473a" }
        }
    }

    // Show Joe as a boy - or his grown up form
    Image {
        source: GameData.currentDifficulty == "child" ? "../../assets/img/joe-01.png" : "../../assets/img/joe-02.png"
        height: parent.height / 2
        fillMode: Image.PreserveAspectFit
        anchors.right: menuScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10 ; anchors.bottomMargin: -5
        anchors.bottom: menuScene.gameWindowAnchorItem.bottom

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
        MenuButton {
            width: parent.width
            text: "Play Endless"
            onClicked: gameSelected("level001-fire-endless")
        }

        MenuButton {
            width: parent.width
            text: "Play Timed"
            onClicked: gameSelected("level002-fire-timed")
        }

        Row {
            spacing: 5
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
