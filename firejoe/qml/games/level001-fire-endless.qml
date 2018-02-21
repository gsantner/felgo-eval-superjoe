import QtQuick 2.0
import VPlay 2.0
import QtQuick.Layouts 1.2
import "../common" as Common
import "../entities" as Entities

Common.GameBase {
    id: game
    gameName: "Endless"
    gameBackgroundOverlay: "fg1.png"
    property variant currentItem: undefined

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
                id: actionWaterbomb
                image: "../../assets/img/item-waterbomb.png"
                cost: 1
                scoreModifier: 1.5
                damage: cost
                isReady: resWater.countCurrent >= cost
                isHighlighted: currentItem === this
                onItemPressed: selectItem(actionWaterbomb)
            }

            Common.ActionItem {
                id: actionBucket
                image: "../../assets/img/item-bucket.png"
                isReady: resWater.countCurrent >= cost
                isHighlighted: currentItem === this
                cost: 2
                damage: cost
                onItemPressed:  selectItem(actionBucket)
            }

            Common.ActionItem {
                id: actionExtinguisher
                image: "../../assets/img/item-extinguisher.png"
                isHighlighted: false
                isReady: true
                cost: 0
                onItemPressed: {
                    isReady = false;
                    var abc = gameScene.getAllEntitiesByType("fire");
                    increaseScore(abc.length);
                    gameScene.entityManager.removeAllEntities();
                }
            }
        }
    }

    function selectItem(item){
        if (resWater.countCurrent >= item.cost) {
            currentItem = item;
        }
    }

    function canDamageEnemy(entityType) {
        return currentItem === undefined ? false : currentItem.damage > 0
    }

    function getEnemyDamage(enemyHealth) {
        if (enemyHealth > 0 && currentItem !== undefined) {
            resWater.countCurrent -= currentItem.cost;
            return currentItem.damage;
        }
        return 0
    }

    function killedEnemy(entityType) {
        increaseScore(1.0 * currentItem.scoreModifier)
    }

    function addFire(count){
        for (var i=0; i < count; i++) {
            gameScene.entityManager.createEntityFromEntityTypeAndVariationType({entityType: "fire"})
        }
        if (gameScene.getAllEntitiesByType("fire").length > 7) {
            gameOver()
        }
    }

    // Kill all enemies, but let all of them just score one point
    function killAllEnemies(){
        for(var otherId in gameScene.entityManager.getEntityArrayByType(entity.entityType)){
            var otherEntity = gameScene.entityManager.getEntityById(entity.entityType + "_" + otherId)
            if (otherEntity === undefined || otherEntity.x === 0 || otherEntity.y === 0) {
                continue;
            }
            if (Math.abs(otherEntity.x - x) > sprite.width && Math.abs(otherEntity.y - y) > sprite.height ){
                break;
            }
        }
    }


    Timer {
        running: gameScene.gameRunning
        repeat: true
        interval: 580
        onTriggered: {
            if (resWater.countCurrent < resWater.countMax){
                resWater.countCurrent++
            }
        }
    }

    Timer {
        running: gameScene.gameRunning
        repeat: true
        interval: 1200
        onTriggered: {
            addFire(1)
        }
    }
}
