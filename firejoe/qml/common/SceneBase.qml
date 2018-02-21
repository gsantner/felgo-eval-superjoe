import VPlay 2.0
import QtQuick 2.0

Scene {
    id: sceneBase

    opacity: 0              // Default invisible - changed by state in Main
    visible: opacity > 0    // A boolean property telling the visibility of this scene
    enabled: visible        // Opacity 0 would just mean transparent - visible false also skips rendering on this scene

    // Always use animation when opacity changes
    Behavior on opacity {
        NumberAnimation {
            property: "opacity"; easing.type: Easing.InOutQuad
        }
    }
}
