pragma Singleton
import VPlay 2.0
import QtQuick 2.0

QtObject {
    id: gameData

    property string gameTitle: "Super Joe"
    property string gameAuthor: "Gregor Santner"

    // We will add support for two modes, child and adult
    property string currentDifficulty: "child"
}
