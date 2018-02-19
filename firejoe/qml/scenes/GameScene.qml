import VPlay 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.2
import "../common"

SceneBase {
    id:gameScene

    property string activeGameFilepath      // Relative path to the game QML file to be loaded
    property variant activeGame             // Object of the current active game
    property int score: 0                   // Score of the current running game
    property int gameStartCountdown: 0      // Countdown to begin the selected game
    property int gamePlayingCountdown: 0    // Countdown till the game is over
    property bool gameOver: false           // Tells if the game is over
    property bool gameRunning: gameStartCountdown == 0 && !gameOver

    // Game background - This time using an image
    Image { source:"../../assets/img/bg1.png" ; anchors.fill:gameWindowAnchorItem }

    Image {
        source: activeGame !== undefined && activeGame !== null && activeGame.gameBackgroundOverlay !== undefined
                ? "../../assets/img/" + activeGame.gameBackgroundOverlay : ""
        anchors.fill: gameWindowAnchorItem
        fillMode: Image.PreserveAspectFit
    }

    // Runtime loading of game - by loading QML Files from the games folder
    function loadGame(gameNameInGamesFolder) { activeGameFilepath = gameNameInGamesFolder; }
    Loader {
        id: loader
        source: activeGameFilepath != "" ? "../games/" + activeGameFilepath + ".qml" : ""
        onLoaded: {
            // since we did not define a width and height in the level item itself, we are doing it here
            item.width = gameScene.width ; item.height = gameScene.height
            // store the loaded level as activeLevel for easier access
            activeGame = item

            // Reset values
            score = 0
            gameStartCountdown = 3
        }
    }

    // Singal connections from the game
    Connections {
        target: activeGame !== undefined ? activeGame : null    // Do not connect if no game is loaded

        // Increase the score by 1
        onIncreaseScore: {
            if(gameRunning) {
                score++
            }
        }
    }

    RowLayout {
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.margins: 10

        // back button to leave scene
        MenuButton {
            text: "Back"
            onClicked: {
                backButtonPressed()
                activeGame = undefined
                activeGameFilepath = ""
            }
        }

        Text {
            Layout.fillWidth: true
            text: activeGame !== undefined && activeGame !== null ? activeGame.gameName : ""
            color: "brown"
            font.bold: true
            font.pixelSize: 20
        }

        Text {
            Layout.fillWidth: true
            color: "white"
            font.pixelSize: 20
            text: "Score: " + score + (gamePlayingCountdown <= 0 ? "" : ("Time: " + gamePlayingCountdown + "s"))
        }
    }

    // Text displaying game status (Countdown / Game Over)
    Text {
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: gameStartCountdown > 0 ? 160 : 80
        text: {
            if (gameStartCountdown > 0) {
                return gameStartCountdown
            }
            if (gameOver) {
                return "Game Over!\nScore:" + score
            }
            return ""
        }
    }

    // Countdown for the game to start
    Timer {
        repeat: true ; interval: 1000
        running: gameStartCountdown > 0
        onTriggered: {
            gameStartCountdown--
        }
    }
}
