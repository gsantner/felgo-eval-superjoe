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
