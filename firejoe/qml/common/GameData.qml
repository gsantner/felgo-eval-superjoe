pragma Singleton
import VPlay 2.0
import QtQuick 2.0

QtObject {
    id: gameData

    property string gameTitle: "Super Joe"
    property string gameAuthor: "Gregor Santner"

    property string currentDifficulty: "child"
}
