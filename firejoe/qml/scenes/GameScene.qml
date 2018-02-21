import VPlay 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.2
import "../common"

SceneBase {
    id:gameScene

    property string activeGameFilepath      // Relative path to the game QML file to be loaded
    property variant activeGame             // Object of the current active game
    property double score: 0                // Score of the current running game
    property int gameStartCountdown: 0      // Countdown to begin the selected game
    property int gamePlayingCountdown: 50    // Countdown till the game is over
    property bool gameOver: false           // Tells if the game is over
    property bool gameRunning: gameStartCountdown == 0 && !gameOver

    // Runtime loading of game - by loading QML Files from the games folder
    function loadGame(gameNameInGamesFolder) { activeGameFilepath = gameNameInGamesFolder; }
    Loader {
        id: loader
        source: activeGameFilepath != "" ? "../games/" + activeGameFilepath + ".qml" : ""
        onLoaded: {
            // Reset values
            gameOver = false
            score = 0
            gameStartCountdown = 3

            // Make games data accessible after loading it
            activeGame = item
            item.width = gameScene.width ; item.height = gameScene.height

        }
    }

    // Signal connections from the game
    Connections {
        target: activeGame !== undefined ? activeGame : null    // Do not connect if no game is loaded

        // Increase the score
        onIncreaseScore: {
            if(gameRunning) {
                score += amount
            }
        }

        onGameOver: {
            gameOver = true
        }
    }

    onGameOverChanged: {
        entityManager.removeAllEntities()
    }

    // Game background - This time using an image
    Image {
        z: -1
        source:"../../assets/img/bg1.png"
        anchors.fill:gameWindowAnchorItem
    }

    // Game background - additional (maybe transparent) overlay, given by game
    Image {
        z: -1
        source: activeGame !== undefined && activeGame !== null && activeGame.gameBackgroundOverlay !== undefined
                ? "../../assets/img/" + activeGame.gameBackgroundOverlay : ""
        anchors.fill: gameWindowAnchorItem
        fillMode: Image.PreserveAspectFit
    }


    // create and remove entities at runtime
    property EntityManager entityManager: EntityManager{
            entityContainer: gameScene
            dynamicCreationEntityList: [
              Qt.resolvedUrl("../entities/FireEntity.qml")
            ]
    }

    onEnabledChanged: {
        if (!enabled){
            entityManager.removeAllEntities()
        }
    }

    // Top information row
    RowLayout {
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.margins: 10

        // Button to leave this game
        MenuButton {
            text: "Back"
            onClicked: {
                backButtonPressed()
                activeGame = undefined
                activeGameFilepath = ""
            }
        }

        // Game title
        Text {
            Layout.fillWidth: true // Adding fillWidth: true on the last two objects will split the available space to two
            text: activeGame !== undefined && activeGame !== null ? activeGame.gameName : ""
            color: "brown"
            font.bold: true
            font.pixelSize: 20
        }

        // Score / Time
        Text {
            horizontalAlignment: Text.AlignRight
            Layout.fillWidth: true
            color: "white"
            font.pixelSize: 18
            text: "Score: " + Math.floor(score) + (gamePlayingCountdown <= 0 ? "" : ("\nTime: " + gamePlayingCountdown + "s"))
        }
    }

    // Text displaying game status (Countdown / Game Over)
    Text {
        anchors.centerIn: parent
        color: "red"
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

    function getAllEntitiesByType(entityType) {
        var all = [];
        for(var id in entityManager.getEntityArrayByType(entityType)) {
            var entity = entityManager.getEntityById(entityType + "_" + id)
            if (entity !== undefined && entity !== null){
                all.push(entity)
            }
        }
        return all;
    }
}
