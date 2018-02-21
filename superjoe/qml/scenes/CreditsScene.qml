import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id:creditsScene

    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        gradient: Gradient {
            GradientStop { position: 0.65; color: "#159957" }
            GradientStop { position: 1.0; color: "#155799" }
        }
    }

    MenuButton {
        text: "Back"
        anchors.margins: 10
        anchors.top: creditsScene.gameWindowAnchorItem.top
        anchors.left: creditsScene.gameWindowAnchorItem.left
        onClicked: backButtonPressed()
    }

    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: "Game created by\n" + GameData.gameAuthor
        color: "white"
    }
}
