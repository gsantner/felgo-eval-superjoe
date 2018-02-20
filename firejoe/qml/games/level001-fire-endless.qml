import QtQuick 2.0
import VPlay 2.0
import QtQuick.Layouts 1.2
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

    Common.ActionBar {
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

            Common.ActionItem {
                image: "../../assets/img/item-waterbomb.png"
                cost: 1
            }

            Common.ActionItem {
                image: "../../assets/img/item-bucket.png"
                isReady: true
                cost: 2
                onItemPressed: {
                    blowOutFire(cost, 0)
                }
            }

            Common.ActionItem {
                image: "../../assets/img/item-extinguisher.png"
                isHighlighted: true
            }
        }
    }

    function blowOutFire(amount, multiplier){
        increaseScore(amount * multiplier)
    }

    function addFire(){

    }

    Timer {
        repeat: true
        interval: 500
        onTriggered: {
            addFire()
        }
    }
}
