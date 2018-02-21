---
layout: post
title: "V-Play Tutorial"
date: 2018-02-16 19:03:35
tags: [dev, v-play, qt]
#excerpt: 'Short text with markdown support'
categories: qt
#image: 'BASEURL/assets/blog/img/.png'
#photos: 'BASEURL/assets/blog/img/.png'
#description:
#permalink:
---

**Notice:: WIP :: This document is work in progress.**  

In this tutorial we will cover howto develop a simple game using the Qt based crossplatform solution [V-Play](https://v-play.net). We will start with some setup notes on a Linux machine. After that the tutorial will covert howto setup and run a sample project and howto actually make a real game out of it. You can find the full source code on [GitHub](https://github.com/gsantner/vplay-eval-superjoe).


Resources: [Qt-5 docs](https://doc.qt.io/qt-5/index.html) , [V-Play docs](https://v-play.net/doc/), [OpenClipArt](https://openclipart.org/) | [Zapsplat (Sounds)](https://www.zapsplat.com/author/cc0/) |

# Project idea
The plan is to develop a game to be used by younger users of mobiles. Especially thinking of my younger neighbour who wants to join the volunteer fire brigade at some point - this should be about one of a firefighters jobs, to blow out a fire.

* Game Name: Super Joe
* Main-Screen
  * Start game - Survival (endless)
  * Start game - TimeAttack (countdown)
  * Switch to adult difficulty
  * About
* Game principle
  * Fire should spawn at random position on the game screen
  * Ressource: Water
  * Blow out fire by using various items
  * Items: water bomb, water bucket, fire extinguisher
  * Each item has a different ressource requirement
  * Score: Each blown out fire scores points
* Game modes
  * In both modes (games), fire will spawn with some delay, when a certain amount is reached the game is over. The player must keep the count below this amount by using items on fires
  * Survival Game: Game runs endless unless the player let too much fire alive. Each blown fire increases score
  * TimeAttack Game: Limited time with countdown. Higher amount of allowed fires. Each blwon fire increases score, but the player must use items appropriately to score high
* Adult difficulty
  * Adds more items and therefore more options to score high
  * Fire accelerator: Spawns some more fire, increases score
  * Beer: Double points for one fire. Clears the water tank

**Naming hints:** A item will be further called a `Spell`, the reason is reuseability and to not mistakenly mix it up with the common QML type `Item`.
The whole application will be a base to start various mini-games (depending on view and amount of reuse it may also be called a level). One such mini-game is named `Game`, the environment of it is the `GameScene`.
The whole application will have its start point in `Main` where navigation between screens do happen. One of such screens/activities/windows is called a `Scene`. The main scene will be the `MenuScene` where the player can choose between options.








# V-Play Setup on Arch Linux
It's very easy to get started, download the package from <https://v-play.net/download/>, unpack and run the `*.run` executable. The `qt5-base` package is already installed on my system so the needed system libraries are installed too <small>(toolchain packaged on arch repos and v-plays toolchain are both quite recent, therefore dependencies of both are fine)</small>. I registered for the free Personal Pricing plan and logged into V-Plays Qt Creator after installation.

![Startup project]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-001.png)

For disambiguation and convinient access to useful tools I created an application launcher:  
<small>Note the Exec line, the library path may need to be adjusted due archs different library packaging. <a href="https://bugreports.qt.io/browse/QTCREATORBUG-18137">(Source)</a></small>
```
[Desktop Entry]
Version=1.0
StartupNotify=false
Type=Application
NoDisplay=false
Terminal=false

Name=V-Play Qt Creator
Icon=%%VPLAY%%/VPlayLive/assets/vplay-logo.png
Exec=bash -c 'LD_LIBRARY_PATH=/usr/lib/openssl-1.0/ %%VPLAY%%/Tools/QtCreator/bin/qtcreator.sh %F'
Keywords=qt;c++;cpp;qml;vplay;v-play;work;qt creator;qtcreator;
Categories=Development;IDE;Qt;
Path=/home/gregor/aaDev/
TryExec=%%VPLAY%%/Tools/QtCreator/bin/qtcreator.sh
Actions=maint;vpdocs;qtdocs;oca;
StartupWMClass=qtcreator

[Desktop Action maint]
Name=MaintenanceTool
Exec=%%VPLAY%%/MaintenanceTool
[Desktop Action vpdocs]
Name=-> V-Play Docs
Exec=xdg-open "https://v-play.net/doc/"
[Desktop Action qtdocs]
Name=-> Qt Docs
Exec=xdg-open "https://doc.qt.io/qt-5/index.html"
[Desktop Action oca]
Name=-> OpenClipArt
Exec=xdg-open "https://openclipart.org/"
``` 

<a name="android_setup"></a>I will too try my first V-Play application on an Android phone. For deployment, both Android [SDK](https://developer.android.com/studio/index.html) and [NDK](https://developer.android.com/ndk/index.html) are needed. They can be set in Qt Creator at `Menu-> Tools-> Devices-> Android`. Qt toolchain components need to be installed too, the needed Android parts can be downloaded using the `MaintenanceTool` executable, which resides in V-Plays root folder.


## Setting up the project
At Qt Creator click at the top menu: `File -> New File or project`. I chose `New - Empty V-Play 2 Project`. The list also contains a lot of other project templates which do include existing assets, logic and components. I gave the game the name `Super Joe`, the reason is that the main screen will have picture of a boy named Joe. Apart from the title I am going to use `superjoe` everywhere else as identifier. This includes the project name as this will be the name of the folder where the project will reside in. As Kits I selected the `V-Play Desktop` and `Android` Kit, as I want to try the game on both. For the latter the Android components must be installed, for this see the [V-Play Setup](#android_setup) chapter. 

![Project Creation]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-002.png)

The `App Idenfitier` will be the later package id, which has to be unique. This ID will be the one that will later identify the app e.g. on Google Play, when the game gets published. There always can be installed one app  one a Android device with this identifier. I will use `net.gsantner.superjoe` for this.

For the `Interface Orientation` I choose `Landscape` since it will give more space for the `HUD`. In the next step V-Play Plugins can be added. In this case I chose none, because I want the game to be fully offline playable. In the last step a VCS can be setted up.













## Starting the application
Starting the application the first time is really easy when the project is properly configured (kits setted up). On the bottom left there are buttons for starting the project, starting in debug mode and for just building. The target device can be configure above these options. V-Play also developed a simple solution to try out the game and game changes immediatly after changing something - `V-Play Live Client`

The live client can be started by using button labeled LIVE and allows to select a single file (as entrence point) to load in a qmlviewer. The client will automatically reload when saving file changes to disk. This works on multiple devices simoutlanously. For Android an additional [app](https://play.google.com/store/apps/details?id=net.vplay.apps.QMLLive) has to be installed.


![Starting the project in V-Play Live Client]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-003.png)


# Setting up the application environment
The selected project template comes already with a good project hierachy and application environment and this is where we start off. In this chapter we will deal with: Deploying + running an application, building an environment to choose between different mini-games and actually display a (mini-)game. 

## First custom component - MenuButton
This is a custom component to be used as a button. On top are the import statements. We will include `QtQuick` and `VPlay` in most components.

```
import QtQuick 2.0

// Inherit from Rectangle component - including all properties and signals
Rectangle {
    /*
    // ID of this component - used inside this component
    // When creating a new button using   MenuButton { id: coolButton }
    // coolButton can be used outside to refer to the instance of the button
    // Inside here, id "button" will still work and can be used to refer to self/this
    */
    id: button

    // Setup custom properties (these are exposed additionally to the Rectangle ones)
    property alias text: buttonText.text // Binds text property to buttonTexts text property
    property int paddingHorizontal: 10
    property int paddingVertical: 5

    // Expose a signal, without arguments
    signal clicked

    // Make use of our new properties
    width:  buttonText.width  + paddingHorizontal * 2
    height: buttonText.height + paddingVertical * 2
    color: "#e9e9e9"
    radius: 10
```

We will use the properties above to create a `Text` component, centered in the whole `MenuButton`. Additionally we want the whole component clickable (including a signal/callback). For this we add a `MouseArea` which forwards a click using the `onClicked` signal. The `MouseArea` should forward the click when we click anywhere inside the button, so we set `anchors.fill: parent` which makes the `MouseArea` fill the whole component.

```
    // Display text inside the rectangle
    Text {
        id: buttonText
        anchors.centerIn: parent
        font.pixelSize: 18
        color: "black"
    }

    // Make the Rectangle actually clickable
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked() // Trigger the clicked signal of self
        onPressed: button.opacity = 0.5
        onReleased: button.opacity = 1
    }
}

```


## Entrance point - Main
This is the main component of the application, which does handle navigation and command switchting between screens and states.

```
GameWindow {
    id: window

    // Implemented Scenes
    MenuScene { id: gameScene }
    GameScene { id: menuScene }

    // Initial states
    state: "menu"
    activeScene: menuScene

    // States to switch between
    // When entering a state it's PropertyChanges will be done
    // in order. When leaving a state the changed properties
    // will get reset to the values before the state was
    // entered. This behaviour is very convienient for
    // the use case of toggling between scenes
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        }
    ]
}
```

## Base class for scenes - SceneBase
This is used as the base for all scenes. The really important point in here is setting the `opacity: 0` as initial value. When changing `opacity` to another value via a `PropertyChange` in the State-Machine and moving on to another state, this will reverted and therefore get invisible again.

```
Scene {
    id: sceneBase

    opacity: 0              // Default invisible - changed by state in Main
    visible: opacity > 0    // A boolean property telling the visibility of this scene
    enabled: visible        // Opacity 0 would just mean transparent - visible false also skips rendering on this scene

    // Always animate opacity changes
    Behavior on opacity {
        NumberAnimation {
            property: "opacity"; easing.type: Easing.InOutQuad
        }
    }
}

```

## Data used overall the game - GameData
This is intended as a compontent holding static data to be used overall in the game. To accomplish this, a single instance of a data container is needed. QML got you covered - with the ability to create Singletons.

First we will create a new file named `GameData.qml`:
```
pragma Singleton
import VPlay 2.0
import QtQuick 2.0

QtObject {
    id: gameData

    property string gameTitle: "Super Joe"
    property string gameAuthor: "Gregor Santner"

    // We will add support for two modes, child and adult
    property string currentDifficulty: "child"
}
```
As seen above, the file needs to have `pragma Singleton` in the same level as the root item.

To create a `Singleton` of a component, too a file named `qmldir` needs to be created in the same directory as the object. In qmldir all files have to be listed that should be made a singleton, including its exported component name:

```
singleton GameData GameData.qml
```


## Main Menu - MenuScene

The actual visible UI of the main screen. It will allow us to start one of the two game modes (Survival, TimeAttack), to switch difficulty and to get to the about scene.


![Menu scene]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-004.png)

The communication to Main.qml happens via signals:
```
import VPlay 2.0
import QtQuick 2.0
import QtMultimedia 5.0
import "../common" // Relative import - All components inside the ../common folder get available

// A scene based on SceneBase
SceneBase {
    id: menuScene

    signal gameSelected(string game)    // Expose game selection
    signal difficulyToggled()           // Toggles the difficulty
    signal aboutSelected()              // Switch to about screen
```

Add a nice red background and a picture of joe. The order of components **does matter**. Components defined more on bottom (code) are above the compontens defined before. This behaviour can be modified by setting the `z` property of an component. All components are by default on the `z: 0` level (_=/layer_). The same principle applies to all components having same `z` value.
```
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
```

V-Plays basic components also include a simple way to play audio files:
```
    // Play sound when menu screen is open
    SoundEffectVPlay {
        muted: !menuScene.enabled
        source: Qt.resolvedUrl("../../assets/sound/nature_fire_big.wav")
        loops: SoundEffect.Infinite
        autoPlay: true
    }
```

Create a `Text` component showing the apps title, wrapped in a colored `Rectangle`. This will add a label with an colored stripe as background.
```
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
```

Now menu options will get added. These options will trigger signals which again will be handled in Main.qml.
```
    // Show the menu
    Column {
        anchors.centerIn: parent
        spacing: 10

        // Sends Main the signal to start specified game
        MenuButton {
            width: parent.width
            text: "Play Survival"
            onClicked: gameSelected("Game000_Example")
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
```

## Base component for games - GameBase
This component act as a common component of all playable games. It will provide information like the games name or the wanted background. It also provides a common way to communicate score changes or game over. These signals will later be handled by the `GameScene`.

```
import QtQuick 2.0
import VPlay 2.0

Item {
    property string gameName                // For displaying the game's name
    property string gameBackgroundOverlay   // Image to be layed over the the background
    property int gameDuration               // The duration of the game or -1 if endless
    signal increaseScore(double amount)     // Increase score by given amount
    signal gameOver()                       // Trigger gameover from inside the game
}
```

## Game UI/Environment - GameScene
This scene should provide the common UI for available games, methods to load a specific game and common non-game specific methods.

Lets start off with loading a game. The code below allows to load a specific game out of the games folder.
If there is a file `qml/games/Game001_Fire_Survival.qml` the method call will be `loadGame("Game001_Fire_Survival")`.
```
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
    property int gameTime: 0                // Countdown or accumulated time of the current game
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
            gameTime = 0

            // Make games data accessible after loading it
            activeGame = item
            gameTime = activeGame.gameDuration
            item.width = gameScene.width ; item.height = gameScene.height
        }
    }
```


Next up is the actual connection to the `GameBase` instance. The implemented slots include score accumulation and handling game over signals. It's always a good idea to check for availability of a game:
```
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
```

Every game needs well-polished graphics. The following adds a general background that is always on the most bottom layer. Additionally we will add a way to let the game decide about the background. As the game may not supply an additional background, this has to be carefully checked. We will set `z: -1` here to make sure backgrounds are always on the very bottom. We allow the token `ASSETIMG` which will be replaced with the relative path to the image assets folder.
```
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
                ? Qt.resolvedUrl(activeGame.gameBackgroundOverlay.replace("ASSETIMG", "../../assets/img")) : ""
        anchors.fill: gameWindowAnchorItem
        fillMode: Image.PreserveAspectFit
    }
```

A game may be boring if there is no enemy. V-Play got us covered with `EntityManager`, which allows easy management of entities (we will later create one such entity: `FireEntity`).
```
    // create and remove entities at runtime
    property EntityManager entityManager: EntityManager {
            entityContainer: gameScene
            dynamicCreationEntityList: [
		// We will later add an entity to here
            ]
    }

    // Remove all entities when the game is over
    onGameOverChanged: {
        entityManager.removeAllEntities()
    }

    // Remove all entities when leaving the game
    onEnabledChanged: {
        if (!enabled){
            entityManager.removeAllEntities()
        }
    }
```


To let the player know whats the current games status, we will add a information bar:
```
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
            color: "#efefef"
            font.pixelSize: 20 ; font.bold: true
        }

        // Score / Time
        Text {
            horizontalAlignment: Text.AlignRight
            Layout.fillWidth: true
            color: "#efefef"
            font.pixelSize: 18
            text: "Score: " + Math.floor(score) + (gameTime <= 0 ? "" : ("    Time: " + gameTime + "s"))
        }
    }
```
![Game information bar]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-005.png)


To finish the first draft of the GameScene we add a countdown. The player will see a big textfield with the time till the game starts. The QML `Timer` component allows to easily add time based functionalities to an application. `repeat` tells if the timer should give a oneshot or should keep running after the first trigger signal. The condition for keep running is set to `gameStartCountdown > 0`, which value will be decreased on every trigger. The countdown gets initalized to 3 when loading a game in the according function.
```
    // Big text displaying game status (Countdown / Game Over)
    Text {
        anchors.centerIn: parent
        color: "black"
        font.pixelSize: gameStartCountdown > 0 ? 160 : 65
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (gameStartCountdown > 0) {
                return gameStartCountdown
            }
            if (gameOver) {
                return "Game Over!\nScore: " + Math.floor(score)
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
```


Additionally we will add an game timer, which handles counting time up or down depending on the games specification.
The properties have to be carefully checked to be on the safe side.

We also add a function to allow our games to determine all available entities, depending on given `entitiyType`.
With this, we get a simple way to access all entities including their data, filtered by type.
```
    // A timer for controlling the ingame time
    Timer {
        repeat: gameRunning ; interval: 1000
        running: gameRunning && activeGame !== undefined && activeGame !== null
                 ? ((activeGame.gameDuration > 0 && gameTime > 0) || activeGame.gameDuration === -1) : false
        onTriggered: {
            gameTime += activeGame.gameDuration === -1 ? 1 : -1
            if (gameTime < 1 && activeGame.gameDuration > 0){
                gameOver = true
            }
        }
    }


    // Get entities by given type
    function getAllEntitiesByType(entityType) {
        var entities = [];
        // Get all available IDs by given entityType
        for(var nr in entityManager.getEntityArrayByType(entityType)) {
            // Get the object. entityManager uses "name_nr" as unqiue identifier
            var entity = entityManager.getEntityById(entityType + "_" + nr)
            if (entity !== undefined && entity !== null){
                entities.push(entity)
            }
        }
        return entities;
    }
```

## Extend Main
If not done yet, be sure to extend `Main` to handle signal sent by our games:

```
import VPlay 2.0
import QtQuick 2.0
import "scenes"
import "common"

GameWindow {
    id: window
    screenWidth: 960
    screenHeight: 640

    // menu scene
    MenuScene {
        id: menuScene
        // listen to the button signals of the scene and change the state according to it
        onGameSelected: {
            // selectedLevel is the parameter of the levelPressed signal
            gameScene.loadGame(game)
            window.state = "game"
        }

        onAboutSelected: window.state = "credits"

        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                if(accepted && window.activeScene === menuScene)
                    Qt.quit()
            }
        }

        onDifficulyToggled: {
            GameData.currentDifficulty = GameData.currentDifficulty == "child" ? "adult" : "child"
        }
    }

    // credits scene
    CreditsScene {
        id: creditsScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onBackButtonPressed: window.state = "menu"
    }

    // Initial states
    state: "menu"
    activeScene: menuScene

    /*
    // States to switch between
    // When entering a state it's PropertyChanges will be done
    // in order. When leaving a state the changed properties
    // will get reset to the values before the state was
    // entered. This behaviour is very convienient for
    // the use case of toggling between scenes
    */
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: window; activeScene: creditsScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        }
    ]
}
```

## Example Game - Game000_Example
This is an example game based upon the common `GameBase` created before. It has a single clickable element in the center which will increase the score upon press.
 
```
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

```

![Example level implementation]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-06.png)

## Conclusion
This was part one of the tutorial: Deploying + running an application, building an environment to choose between different mini-games and actually display a (mini-)game. The next part will deal with actually making a useable application out of it :).



# Designing the game
First off we will start by creating a new game, `Game001_Fire_Survival`. Simply copy or move the existing example game and change the game reference for the Survival Mode in the `MenuScene`.
We will later come back to this.

## A item list - SpellBar
This component should be a bar on the bottom with spells (/=items) to choose from. We will add some spells to a instance of our new `SpellBar` component in the next step.

```
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
```


![SpellBar.qml]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-007.png)


## SpellButton
This component should provide a clickable spell icon. It too should be able to visualize highlight (selection) and ready states.

Create a component in a squircle shape exposing properties and the selected signal:
```
import VPlay 2.0
import QtQuick 2.0

Rectangle {
    id: spell

    property int cost: 1                // Store how much resources this spell takes
    property int damage: 1              // Store how much damage this spell deals
    property double scoreModifier: 1    // Factor for calculating the score
    property bool isHighlighted: false
    property bool isReady: false
    property double itemSize: parent.height
    property string image: ""
    property string sound: ""

    signal spellCasted

    width: itemSize * (isHighlighted ? 1 : 0.8) ; height: width
    anchors.verticalCenter: parent.verticalCenter

    // Lets make a light squircle
    radius: height * 0.4
    color: "#bfbfbf"
```

The following allows to visualize the items state:
```
    // Make border dependent on the item state
    border.color: isHighlighted ? "red" : (isReady ? "turquoise" : "transparent")
    border.width: itemSize * 0.05
```

Add an picture to it's center and make the whole item clickable. Lets also forward the click signal:
```
    Image {
        source: image !== undefined && image !== "" ? Qt.resolvedUrl(image.replace("ASSETIMG", "../../assets/img")) : ""
        anchors.fill: parent
        anchors.margins: parent.height * 0.1
        fillMode: Image.PreserveAspectFit
    }

    // Make width changes animated
    Behavior on width {  NumberAnimation { property: "width" ; easing.type: Easing.InOutExpo }}

    // Forward the click
    MouseArea {
        anchors.fill: parent
        onClicked: gameScene.gameRunning && isReady && spellCasted()
    }
}
```

The spell should also have a associated sound:
```
    SoundEffectVPlay {
        id: soundFx
        source: sound !== undefined && sound !== "" ? Qt.resolvedUrl(sound.replace("ASSETSOUND", "../../assets/sound")) : ""
    }

    // Playback sound, dont overlap
    function playSound(){
        if (!soundFx.playing){
            soundFx.play()
        }
    }
}
```


## Water tank
Lets add a water tank to our game, to show how much ressources are available. We will add this to the end of our `SpellBar` to save some screen space for the actual game area.

We will create a reuseable `ResourceBar` Component for this:
```
import VPlay 2.0
import QtQuick 2.0

Item {
    id: item

    property int barRotation: 180       // To allow both, vertical and horizontal direction
    property int countCurrent: 0        // The current amount of available resources
    property int countMax: 5            // The maximum amount of ressources
    property string borderColor: "gray"

    // Properties can also be initialized with an object
    property Gradient resourceGradient: Gradient {
        GradientStop { position: 0.0; color: "#74ebd5" }
        GradientStop { position: 1.0; color: "#acb6e5" }
    }

    rotation: barRotation
    height: parent.height
    width: 80

    Column {
```

A Repeater will create the contained item multiple times, according to the count of `model`:
```
        // Repeat a bar multiple times
        Repeater {
            model: item.countMax
            Rectangle {
                visible: index < countCurrent
                width: item.width; height: item.height / item.countMax
                radius: width * 0.1
                border.width: 1 ; border.color: item.borderColor
                gradient: item.resourceGradient
            }
        }
    }
}
```

## Putting the SpellBar into our game
Lets add the newly created `SpellBar` to our game, including some spells. You can remove the existing rectangles.
```
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Layouts 1.2
import "../common" as Common
import "../entities" as Entities

Common.GameBase {
    id: game
    gameName: "Survival"
    gameBackgroundOverlay: "ASSETIMG/fg1.png"
    gameDuration: -1

    Common.SpellBar {
        Row {
            anchors.fill: parent
            anchors.leftMargin: spacing * 2
            spacing: height * 0.1

            Common.ResourceBar {
                id: resWater
                width: parent.height * 1.25
                countCurrent: 5 // Lets start the game with 5
                countMax: 15
                barRotation: 0
            }

            // Slow spell for a higher score
            Common.SpellButton {
                id: spellWaterbomb
                cost: 1 ; scoreModifier: 1.5 ; damage: cost
                image: "ASSETIMG/item-waterbomb.png" ; sound: "ASSETSOUND/watersplash.wav"
                isReady: false
                isHighlighted: false
            }

            // Scaling waterbombs options to two excluding modifier
            Common.SpellButton {
                id: spellBucket
                cost: 2 ; scoreModifier: 1.0 ; damage: cost
                image: "ASSETIMG/item-bucket.png" ; sound: "ASSETSOUND/watersplash.wav"
                isReady: true
                isHighlighted: false
            }

            // One time useable, kills all fire enemies, gives less points
            Common.SpellButton {
                id: spellExtinguisher
                cost: 0 ; damage: 99 ; scoreModifier: 0.85
                image: "ASSETIMG/item-extinguisher.png" ; sound: "ASSETSOUND/ignition.wav"
                isHighlighted: true
                isReady: true
            }
        }
    }
}
```

![Game with SpellBar]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-009.png)



## Lets add an entity - Fire enemy
Now lets add some fire. For this we extend `EntityBase` which is required for the entity to be manageable by `EntityManager` - which is used to dynamically create and identify our objects.

```
import QtQuick 2.0
import VPlay 2.0
import "../common"

EntityBase {
    id: entity
    entityType: "fire"      // This must be specified - used to identify and create objects of this entity

    property int health: 3  // Store the health of this entity

    // Make this entitys size entirely dependent on the image
    width: sprite.width
    height: sprite.height
    MultiResolutionImage {
        id: sprite
        source: "../../assets/img/fire1.png"
    }
```

Here we will ask the current running game for some details (to be added in next point):
```
    // Ask the current running game if an spell is available and applies its damage
    MouseArea {
        anchors.fill: sprite
        onPressed: {
            if (gameScene.activeGame.canDamageEnemy(entity)) {
                entity.health -= gameScene.activeGame.getDealableDamage(entity, entity.health)
                if (entity.health <= 0){
                    gameScene.activeGame.onEnemyKilled(entity)
                    removeEntity()
                }
            }
        }
    }
```

We will position the fire randomly somewhere in the height center and try to not be in range of existing fires:
```
    // After creating this entity randomnize its screen position, somewhere in the middle
    Component.onCompleted: {
        var x = 0;
        var y = 0;

        // Try 20 times to find a suiteable position for the item
        for (var i=0 ; i < 10 ; i++) {
            x = utils.generateRandomValueBetween(0, gameScene.width-sprite.width)
            y = gameScene.height * 0.17 + utils.generateRandomValueBetween(0, gameScene.height * 0.48)

            // Browse through all other entities for existing positions
            for(var otherEntity in gameScene.getAllEntitiesByType(entity.entityType)){
                if (otherEntity.x === 0 || otherEntity.y === 0){
                    continue;
                }
                // Dont overlay the other entity
                if (Math.abs(otherEntity.x - x) > sprite.width * 1.1
                        && Math.abs(otherEntity.y - y) > sprite.height * 1.1){
                    break;
                }
            }
        }

        // Finally apply the position
        entity.x = x;
        entity.y = y;
    }
}

```

Now extend the entityManager in the `GameScene`:
```
            dynamicCreationEntityList: [
              Qt.resolvedUrl("../entities/FireEntity.qml")
            ]
```

### Implementing the Survival game
We can reuse most parts of our `SpellBar` example:

```
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Layouts 1.2
import "../common" as Common
import "../entities" as Entities

Common.GameBase {
    id: game
    gameName: "Survival"
    gameBackgroundOverlay: "ASSETIMG/fg1.png"
    gameDuration: -1

    property variant currentSpell: spellWaterbomb
    property int gameOverAmountOfFire: 7

    Common.SpellBar {
        Row {
            anchors.fill: parent
            anchors.leftMargin: spacing * 2
            spacing: height * 0.1

            Common.ResourceBar {
                id: resWater
                width: parent.height * 1.25
                countCurrent: 5 // Lets start the game with 5
                countMax: 15
            }
```

We are going to save the current selected spell, according to this the damage gets dealt and the score calculated:
```
            // Slow spell for a higher score
            Common.SpellButton {
                id: spellWaterbomb
                cost: 1 ; scoreModifier: 1.5 ; damage: cost
                image: "ASSETIMG/item-waterbomb.png" ; sound: "ASSETSOUND/watersplash.wav"
                isReady: resWater.countCurrent >= cost
                isHighlighted: isReady && currentSpell === this
                onSpellCasted: currentSpell = this
            }

            // Scaling waterbombs options to two excluding modifier
            Common.SpellButton {
                id: spellBucket
                cost: 2 ; scoreModifier: 1.0 ; damage: cost
                image: "ASSETIMG/item-bucket.png" ; sound: "ASSETSOUND/watersplash.wav"
                isReady: resWater.countCurrent >= cost
                isHighlighted: isReady && currentSpell === this
                onSpellCasted: currentSpell = this
            }

            // Beer gives double points but empties all resources
            Common.SpellButton {
                id: spellBeer
                cost: resWater.countCurrent ; damage: 99 ; scoreModifier: 2
                visible: Common.GameData.currentDifficulty === "adult"
                image: "ASSETIMG/item-beer.png" ; sound: "ASSETSOUND/beer.wav"
                isHighlighted: isReady && currentSpell === this
                isReady: resWater.countCurrent > 5
                onSpellCasted: currentSpell = this
            }
```

Now some special spells, the first one adds the ability to add more fire and also increase the score:
```
            // Accelerator adds more fire and gives some points
            Common.SpellButton {
                id: spellFireAccelerator
                visible: Common.GameData.currentDifficulty === "adult"
                image: "ASSETIMG/item-fire-accelerator.png" ; sound: "ASSETSOUND/ignition.wav"
                isHighlighted: false
                isReady: true
                onSpellCasted: {
                    if (gameScene.getAllEntitiesByType("fire").length + 2 < gameOverAmountOfFire){
                        addFireEnemy(2)
                        increaseScore(10 * 3)
                    }
                }
            }
```

The other one is a one-time consumeable, which kills everything:
```
            // One time useable, kills all fire enemies, gives less points
            Common.SpellButton {
                id: spellExtinguisher
                cost: 0 ; damage: 99 ; scoreModifier: 0.85
                image: "ASSETIMG/item-extinguisher.png" ; sound: "ASSETSOUND/ignition.wav"
                isHighlighted: false
                isReady: true
                onSpellCasted: {
                    isReady = false;
                    increaseScore(10 * scoreModifier * gameScene.getAllEntitiesByType("fire").length);
                    gameScene.entityManager.removeAllEntities();
                    playSound()
                }
            }
        }
    }
```

Increase ressources on time basis, the same for enemies
```
    // Increment ressources (water) till the tank is full
    Timer {
        interval: 320
        repeat: true ; running: gameScene.gameRunning
        onTriggered: {
            if (resWater.countCurrent < resWater.countMax){
                resWater.countCurrent++
            }
        }
    }

    // Add fire repeatedly
    Timer {
        interval: 1100
        repeat: true ; running: gameScene.gameRunning
        onTriggered: {
            addFireEnemy(1)
        }
    }
```

This is the actual function to add a new enemy:
```
    // Generate a new enemy of type fire
    function addFireEnemy(count){
        for (var i=0; i < count; i++) {
            gameScene.entityManager.createEntityFromEntityTypeAndVariationType({entityType: "fire"})
        }
        if (gameScene.getAllEntitiesByType("fire").length >= gameOverAmountOfFire) {
            gameOver()
        }
    }
```

These act as a callback for the `Fire` entity:
```
    // Check if there is some spell selected and if it can damage the enemy
    function canDamageEnemy(entityEnemy) {
        return currentSpell === undefined
                ? false : (currentSpell.damage > 0 && currentSpell.isReady)
    }

    // Get the amount of damage targeted at the enemy
    function getDealableDamage(entityEnemy, enemyHealth) {
        if (enemyHealth > 0 && currentSpell !== undefined) {
            resWater.countCurrent = Math.max(0, resWater.countCurrent - currentSpell.cost);
            currentSpell.playSound()
            return currentSpell.damage;
        }
        return 0
    }

    // Callback from an enemy, when it was killed
    function onEnemyKilled(entityEnemy) {
        increaseScore(10 * currentSpell.scoreModifier)
    }
}

```

Thats it, we have completed our first game mode.
![Game with ActionBar]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-010.png)


## Implementing the TimeAttack game
We can reuse most parts of our `Survival` game, create a new game named `Game002_Fire_TimeAttack` and copy over the contents.

Additionaly: 

* Change `gameDuration` to 120 - This the time the time will count down
* Change `gameOverAmountOfFire` to 10 - This will allow more enemies in this mode

Slightly modify our game timers and you completed the second game:
```
    // Increment ressources (water) till the tank is full
    Timer {
        interval: 280
        repeat: true ; running: gameScene.gameRunning
        onTriggered: {
            if (resWater.countCurrent < resWater.countMax){
                resWater.countCurrent++
            }
        }
    }

    // Add fire repeatedly
    Timer {
        property bool firstEnemyPlacement: true

        interval: firstEnemyPlacement ? 100 : 2500
        repeat: true ; running: gameScene.gameRunning  && gameScene.gameTime >= 5
        onTriggered: {
            var amount = firstEnemyPlacement ? 5 : 3
            firstEnemyPlacement = false
            addFireEnemy(amount)
        }
    }
```

# Finished
Thanks for following the tutorial and coming to this point.
It was a pleasure for me to develop this game and hope it can help you out to build your first game using V-Play.
If you have some open questions or missed something you can always [contact me](https://gsantner.net/#contact).
