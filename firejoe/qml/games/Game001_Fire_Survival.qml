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

    // Generate a new enemy of type fire
    function addFireEnemy(count){
        for (var i=0; i < count; i++) {
            gameScene.entityManager.createEntityFromEntityTypeAndVariationType({entityType: "fire"})
        }
        if (gameScene.getAllEntitiesByType("fire").length >= gameOverAmountOfFire) {
            gameOver()
        }
    }

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
