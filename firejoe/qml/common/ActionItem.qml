import VPlay 2.0
import QtQuick 2.0

Rectangle {
    id: actionItem

    property int cost: 1            // Store how much resources this item takes
    property int damage: 1          // Store how much damage this item deals
    property double scoreModifier: 1   // Factor for calculating the score
    property bool isHighlighted: false
    property bool isReady: false
    property double itemSize: parent.height
    property string image: ""

    signal itemPressed

    width: itemSize * (isHighlighted ? 1 : 0.8) ; height: width
    anchors.verticalCenter: parent.verticalCenter

    // Lets make a light squircle
    radius: height * 0.4
    color: "#bfbfbf"

    // Make border dependent on the item state
    border.color: isHighlighted ? "red" : (isReady ? "turquoise" : "transparent")
    border.width: itemSize * 0.05

    Image {
        source: image
        anchors.fill: parent
        anchors.margins: parent.height * 0.1
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        onClicked: gameScene.gameRunning && isReady && itemPressed()
    }
}
