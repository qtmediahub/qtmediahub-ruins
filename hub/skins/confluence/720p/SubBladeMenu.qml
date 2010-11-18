import QtQuick 1.0
import "components"

ListView {
    id: list
    anchors.fill: parent
    delegate: ConfluenceText {
        id: delegate
        anchors { right: parent.right; rightMargin: 20 }
        font.pointSize: 30
        text: model.modelData.name
        horizontalAlignment: Text.AlignRight
        transformOrigin: Item.Right
        width: parent.width
    }
}
