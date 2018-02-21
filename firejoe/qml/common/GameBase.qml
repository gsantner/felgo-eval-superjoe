import QtQuick 2.0
import VPlay 2.0

Item {
    property string gameName                // For displaying the game's name
    property string gameBackgroundOverlay   // Image to be layed over the the background
    property int gameDuration               // The duration of the game or -1 if endless
    signal increaseScore(double amount)     // Increase score by given amount
    signal gameOver()                       // Trigger gameover from inside the game
}
