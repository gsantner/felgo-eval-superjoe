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

    // Make border dependent on the item state
    border.color: isHighlighted ? "red" : (isReady ? "turquoise" : "transparent")
    border.width: itemSize * 0.05


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
