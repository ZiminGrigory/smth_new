import QtQuick 2.6
import QtQuick.Controls 2.0
import io.qt.examples.backend 1.0

ApplicationWindow {
    id: root
    width: 300
    height: 480
    visible: true

    property BackEnd backendFromCPP: null

    Component.onCompleted: {
        backendFromCPP = insertedBackEnd
    }

    TextField {
        id: field
        text: backendFromCPP.userName
        placeholderText: qsTr("User name")
        anchors.centerIn: parent

        onTextChanged: backendFromCPP.userName = text
    }

    Button {
        text: "click me"
        onClicked: {
            backendFromCPP.userName = backendFromCPP.userName + '*'
            field.text = backendFromCPP.userName
        }
    }
}
