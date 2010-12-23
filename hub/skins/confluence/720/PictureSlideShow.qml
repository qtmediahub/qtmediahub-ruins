import QtQuick 1.0
import ModelIndexIterator 1.0
import "../components/"

Item {
    id: root
    property bool running : false
    property variant pictureModel
    property variant rootIndex
    anchors.fill: parent

    function restart() {
        modelIndexIterator.restart()
        running = true
    }

    Image {
        id: image
        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop

        ModelIndexIterator {
            id: modelIndexIterator
            model: root.pictureModel
            rootIndex: root.rootIndex
            filterRole: "type"
            filterValue: "File"
            dataRole: "fileUrl"
        }

        Timer {
            id: timer
            running: root.running
            repeat: true
            interval: 3000
            triggeredOnStart: true
            onTriggered:  {
                root.running = modelIndexIterator.next()
                image.source = root.running ? modelIndexIterator.data : ""
            }
        }
    }
}

