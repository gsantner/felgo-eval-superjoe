import QtQuick 2.0
import VPlay 2.0
import "../common"

EntityBase {
    id: entity
    entityType: "fire"

    property int health: 2

    width: sprite.width
    height: sprite.height


    MultiResolutionImage {
        id: sprite
        source: "../../assets/img/fire1.png"
    }

    CircleCollider {
        radius: sprite.width/2
        fixture.restitution: 0.5
    }

    MouseArea {
        anchors.fill: sprite
        onPressed: {
            // if you touch a balloon and the game is running, it will pop
            /*if(balloonScene.gameRunning) {
                balloonScene.balloons--
                popSound.play()
                removeEntity()
            }*/
            if (gameScene.activeGame.canDamageEnemy(entity.entityType)) {
                entity.health -= gameScene.activeGame.getEnemyDamage(entity.health)
                if (entity.health <= 0){
                    gameScene.activeGame.killedEnemy(entityType)
                    removeEntity()
                }
            }
        }
    }

    Component.onCompleted: {
        var x = 0;
        var y = 0;

        // Try 20 times to find a suiteable position for the item
        for (var i=0 ; i < 10 ; i++) {
            x = utils.generateRandomValueBetween(0, gameScene.width-sprite.width)
            y = gameScene.height * 0.17 + utils.generateRandomValueBetween(0, gameScene.height * 0.5)

            // Browse through all other entities for existing positions
            for(var otherEntity in gameScene.getAllEntitiesByType(entity.entityType)){
                if (otherEntity.x === 0 || otherEntity.y === 0){
                    continue;
                }
                if (Math.abs(otherEntity.x - x) > sprite.width
                        && Math.abs(otherEntity.y - y) > sprite.height ){
                    break;
                }
            }
        }
        entity.x = x;
        entity.y = y;
    }
}
