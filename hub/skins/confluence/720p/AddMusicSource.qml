import QtQuick 1.0
import "components"
import DirModel 1.0

ModalDialog {
    id: root
    title: qsTr("Add Music source")

    content : Item {
        anchors.fill: parent

        Column {
            anchors.fill: parent;
            spacing: 5
            Text {
                id: browseLabel
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("BROWSE FOR THE MEDIA LOCATIONS")
                color: "blue"
            }
            TreeView {
                id: fileSystemView
                width: parent.width
                height: parent.height - browseLabel.height - sourceNameLabel.height - sourceNameInput.height - buttonBox.height 
                        - parent.spacing * 4 // ugh
                treeModel : DirModel { }
                onRootIndexChanged: sourceNameInput.text = treeModel.baseName(rootIndex)
            }
            Text {
                id: sourceNameLabel
                width: parent.width
                text: qsTr("ENTER A NAME FOR THIS MEDIA SOURCE.")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "blue"
            }
            TextInput {
                id: sourceNameInput
                width: parent.width
                text: " "
                color: "white"
            }
            DialogButtonBox {
                id: buttonBox
                anchors.horizontalCenter: parent.horizontalCenter
                onAccept: {
                    musicEngine.pluginProperties.musicModel.addSearchPath(fileSystemView.treeModel.filePath(fileSystemView.rootIndex), sourceNameInput.text);
                    root.close()
                }
                onReject: {
                    root.reject()
                    root.close()
                }
            }
        }
    }
}

