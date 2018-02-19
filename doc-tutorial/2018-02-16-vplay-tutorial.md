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
Resources: [Qt-5 docs](https://doc.qt.io/qt-5/index.html) , [V-Play docs](https://v-play.net/doc/), [OpenClipArt](https://openclipart.org/)


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




# Project idea
My plan is to develop a game to be used by younger users of mobiles. Especially thinking of my younger neighbour who wants to join at the volunteer fire brigade at some point - this should be about one of a firefighters jobs, to blow out a fire.

For this my goal is the following:

* Main-Screen
  * Start game - timed
  * Start game - endless
  * Switch to adult difficulty
  * About
* Game principle
  * Fire should spawn at random position on the game screen
  * Ressource: Water
  * Blow out fire by using various items
  * Items: water bomb, water bucket, fire extinguisher, high pressure water beam
  * Each item has a different ressource requirement (amount)
  * Score: Each blown out fire scores points
* Timed mode: Blow out everything before the time runs out. Fire will spawn with some delay till a certain amount is reached
* Endless mode: Keep the amount of fire below a certain count. New fire keeps spawning
* Adult difficulty: Adds items
  * Fire accelerant: Tripple points for one fire. Spawns 2 more fire
  * Beer: Double points for one fire. Clears the water tank
* Game Name?: Fire Joe

## Setting up the project
At Qt Creator click at the top menu: `File -> New File or project`. I chose `New - Empty V-Play 2 Project`. The list also contains a lot of other project templates which do include existing assets, logic and components. I gave the game the name `Fire Joe`, the reason is that the main screen will have picture of a boy named Joe. Apart from the title I am going to use `firejoe` everywhere else as identifier. This includes the project name as this will be the name of the folder where the project will reside in. As Kits I selected the `V-Play Desktop` and `Android` Kit, as I want to try the game on both. For the latter the Android components must be installed, for this see the [V-Play Setup](#android_setup) chapter. 

![Project Creation]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-002.png)

The `App Idenfitier` will be the later package id, which has to be unique. This ID will be the one that will later identify the app e.g. on Google Play, when the game gets published. There always can be installed one app  one a Android device with this identifier. I will use `net.gsantner.firejoe` for this.

For the `Interface Orientation` I choose `Landscape` since it will give more space for the `HUD`. In the next step V-Play Plugins can be added. In this case I chose none, because I want the game to be fully offline playable. In the last step a VCS can be setted up.


## Starting the application
Starting the application the first time is really easy when the project is properly configured (kits setted up). On the bottom left there are buttons for starting the project, starting in debug mode and for just building. The target device can be configure above these options. V-Play also developed a simple solution to try out the game and game changes immediatly after changing something - `V-Play Live Client`

The live client can be started by using button labeled LIVE and allows to select a single file (as entrence point) to load in a qmlviewer. The client will automatically reload when saving file changes to disk. This works on multiple devices simoutlanously. For Android an additional [app](https://play.google.com/store/apps/details?id=net.vplay.apps.QMLLive) has to be installed.


![Starting the project in V-Play Live Client]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-003.png)


# Setting up the application environment
The selected project template comes already with a good project hierachy and application environment and this is where we start off. In this chapter we will deal with: Deploying + running an application, building an environment to choose between different mini-games and actually display a (mini-)game.


## First custom component - common/MenuButton.qml
This is a custom component to be used as a button.

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


## Entrance point - Main.qml
This is the main component of the application, which does handle navigation and command switchting between screens and states.

```
GameWindow {
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

## Base class for scenes - common/SceneBase.qml
This is used as the root class for all scenes. The really important point in here is setting the `opacity: 0` as initial value. When changing `opacity` to another value via a `PropertyChange` in the State-Machine and moving on to another state, this will reverted and therefore get invisible again.

```
Scene {
    id: sceneBase

    opacity: 0              // Default invisible - changed by state in Main
    visible: opacity > 0    // A boolean property telling the visibility of this scene
    enabled: visible        // Opacity 0 would just mean transparent - visible false also skips rendering on this scene

    Behavior on opacity {   // Always use animation when changing opacity
        NumberAnimation {
            property: "opacity"; easing.type: Easing.InOutQuad
        }
    }
}
```

## Main Menu - scenes/MenuScene.qml

The actual visible UI of the main screen. It will be used to start one of the two game modes (timed, endless), to switch difficulty and to get to the about scene.


![Menu scene]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-004.png)

The communication to Main.qml happens via signals:
```
import VPlay 2.0
import QtQuick 2.0
import "../common"

// A scense based on SceneBase
SceneBase {
    id: menuScene

    signal gameSelected(string level)               // Expose game selection
    signal difficulyToggled()                       // Toggles the difficulty
    signal aboutSelected()

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

Create a `Text` component showing the apps title, wrapped in a colored `Rectangle`:
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

Now menu options will get added. These will trigger signals which will be handled in Main.qml.
```
    // Show the menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        MenuButton {
            width: parent.width
            text: "Play Timed"
            onClicked: gameSelected("level001-fire-timed")
        }

        MenuButton {
            width: parent.width
            text: "Play Endless"
            onClicked: gameSelected("level002-fire-endless")
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
```


## Data used overall the game - common/GameData.qml
This is intended as a compontent holding static data to be used overall in the game. To accomplish this, a single instance of a data container is needed. QML got you covered - with the ability to create Singletons.

First we will create a new file named `GameData.qml`:
```
pragma Singleton
import VPlay 2.0
import QtQuick 2.0

QtObject {
    id: gameData

    property string gameTitle: "Fire Joe"
    property string gameAuthor: "Gregor Santner"

    property string currentDifficulty: "child"
}

```
As seen above, the file needs to have `pragma Singleton` in the level above the root item.

To create a `Singleton` of a component, too a file named `qmldir` needs to be created in the same directory as the object. In qmldir all files have to be listed that should be made a singleton, including its exported name:

```
singleton GameData GameData.qml
```


## GameBase - common/GameBase.qml
This component acts a common component of all playable games. It will provide information like the games name or the wanted background. It also provides a common way to communicate score changes or game over. These signals will later be handled by the `GameScene`.

```
import QtQuick 2.0

Item {
    property string gameName                // For displaying the game's name
    property string gameBackgroundOverlay   // Image to be layed over the the background
    property string isEndless               // Decides if gameTime counter goes up or down
    signal increaseScore(int amount)        // Increase score by given amount
    signal gameOver()                       // Trigger gameover from inside the game
}
```

## Game UI - scene/GameScene
This scene should provide the common UI for available games and methods to load a specific game.

Lets start off with loading a game. The code below allows to load a specific game out of the games folder.
If there is a file `qml/games/level001-fire-endless.qml` the method call will be `loadGame("level001-fire-endless")`.
```
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

    // Runtime loading of game - by loading QML Files from the games folder
    function loadGame(gameNameInGamesFolder) { activeGameFilepath = gameNameInGamesFolder; }
    Loader {
        id: loader
        source: activeGameFilepath != "" ? "../games/" + activeGameFilepath + ".qml" : ""
        onLoaded: {
            // Make games data accessible after loading it
            activeGame = item
            item.width = gameScene.width ; item.height = gameScene.height

            // Reset values
            score = 0
            gameStartCountdown = 3
        }
    }
```


Next up is the actual connection to the GameBase instance. Currently the only implemented function is to increase the counter when the signal gets sent. It's always a good idea to check for unavailable game data:
```
    // Signal connections from the game
    Connections {
        target: activeGame !== undefined ? activeGame : null    // Do not connect if no game is loaded

        // Increase the score by 1
        onIncreaseScore: {
            if(gameRunning) {
                score++
            }
        }
    }
```

Every game needs a well-polished background. The following adds a general background that is always on the most bottom layer. Additionally we will add a way to let the game decide about the background. As the game may not supply an additional background, this has to be carefully checked. We will set `z: -1` here to make sure backrounds are always on the very bottom.
```
    // Game background - This time using an image instead of a Gradient
    Image {
        z: -1
        source:"../../assets/img/bg1.png"
        anchors.fill: gameWindowAnchorItem
    }

    // Game background - additional (maybe transparent) overlay, given by game
    Image {
        z: -1
        source: activeGame !== undefined && activeGame !== null && activeGame.gameBackgroundOverlay !== undefined
                ? "../../assets/img/" + activeGame.gameBackgroundOverlay : ""
        anchors.fill: gameWindowAnchorItem
        fillMode: Image.PreserveAspectFit
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
            color: "brown"
            font.bold: true
            font.pixelSize: 20
        }

        // Score / Time
        Text {
            Layout.fillWidth: true
            color: "white"
            font.pixelSize: 20
            text: "Score: " + score + (gamePlayingCountdown <= 0 ? "" : ("Time: " + gamePlayingCountdown + "s"))
        }
    }
```
![Game information bar]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-005.png)


To finish the first draft of the GameScene we add a countdown. The player will see a big textfield with the time till the game starts. The QML `Timer` component allows to easily add time based functionalities to an application. `repeat` tells if the timer should give a oneshot or should keep running after the first trigger signal. The condition for keep running is set to `gameStartCountdown > 0`, which value will be decreased on every trigger. The countdown gets initalized to 3 when loading a game in the according function.
```
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
```

### Implementation of an example level -- games/level001-fire-endless.qml
This is an example game based upon the common `GameBase` created before. It has a single clickable element in the center which will increase the score upon press.
 
```
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
```

![Example level implementation]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-006.png)

### Conclusion
This was part one of the tutorial: Deploying + running an application, building an environment to choose between different mini-games and actually display a (mini-)game. The next part will deal with actually making a useable application out of it :).
















































## post - bottom anchor

