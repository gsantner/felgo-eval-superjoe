import QtQuick 2.0

Item {
    property string gameName                // For displaying the level's name
    property string gameBackgroundOverlay   // Image to be layed over the the background
    property string isEndless               // Decides if gameTime counter goes up or down
    signal increaseScore(int amount)        // Increase score by given amount
    signal gameOver()                       // Trigger gameover from inside the game
}
