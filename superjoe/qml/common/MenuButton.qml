import QtQuick 2.0

// Inherit from Rectangle component - including all properties and signals
Rectangle {
    /*
    // ID of this component - used inside this component
    // When creating a new button using   MenuButton { id: coolButton }
    // coolButton can be used outside to refer to the instance of the button
    // Inside here, id "button" will still work and can be used to refer to self/this
    */
    id: button

    // Setup custom properties (these are exposed additionally to the Rectangle ones)
    property alias text: buttonText.text // Binds text property to buttonTexts text property
    property int paddingHorizontal: 10
    property int paddingVertical: 5

    // Expose a signal, without arguments
    signal clicked

    // Make use of our new properties
    width:  buttonText.width  + paddingHorizontal * 2
    height: buttonText.height + paddingVertical * 2
    color: "#e9e9e9"
    radius: 10

    // Display text inside the rectangle
    Text {
        id: buttonText
        anchors.centerIn: parent
        font.pixelSize: 18
        color: "black"
    }

    // Make the Rectangle actually clickable
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked() // Trigger the clicked signal of self
        onPressed: button.opacity = 0.5
        onReleased: button.opacity = 1
    }
}
