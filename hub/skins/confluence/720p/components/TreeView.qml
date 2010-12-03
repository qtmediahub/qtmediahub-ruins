import QtQuick 1.0

ListView {
    id: listView
    property alias treeModel : visualDataModel.model
    property alias rootIndex : visualDataModel.rootIndex
    signal clicked()
    signal rootIndexChanged() // this should be automatic, but doesn't trigger :/

    function currentModelIndex() {
        //console.log(currentItem.itemdata.filePath);
        return visualDataModel.modelIndex(currentIndex);
    }

    model : visualDataModel

    VisualDataModel {
        id: visualDataModel
        delegate : Item {
            property variant itemdata : model
            width: listView.width
            height: sourceText.height + 8
            Image {
                id: backgroundImage
                anchors.fill: parent; 
                source: themeResourcePath + "/media/" + (ListView.isCurrentItem ? "MenuItemFO.png" : "MenuItemNF.png");
            }
            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                z: 1 // ensure it is above the background
                text: model.display
                font.pointSize: 16
                color: "white"
            }

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                onEntered:
                    listView.currentIndex = index
                onClicked: {
                    if (model.hasModelChildren) {
                        visualDataModel.rootIndex = visualDataModel.modelIndex(index)
                        listView.rootIndexChanged();
                    } else if (model.display == qsTr("..")) {
                        visualDataModel.rootIndex = visualDataModel.parentModelIndex();
                        listView.rootIndexChanged();
                    } else {
                        listView.currentIndex = index;
                        listView.clicked()
                    }
                }
            }
        }
    }
}

