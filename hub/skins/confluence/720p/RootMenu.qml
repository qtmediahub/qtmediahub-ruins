import QtQuick 1.0
import "components"


FocusScope {
    id: rootMenu
    height: parent.height; width: parent.width

    property variant menuSoundEffect
    property string name: "rootmenu"
    property alias currentItem: rootMenuList.currentItem
    property alias currentIndex: rootMenuList.currentIndex
    property alias buttonGridX : buttonGrid.x

    signal openSubMenu

    Component.onCompleted: {
        var clickComponent = Qt.createComponent("components/QMHAudio.qml");
        if(clickComponent.status == Component.Ready) {
            menuSoundEffect = clickComponent.createObject(parent)
            menuSoundEffect.source = themeResourcePath + "/sounds/click.wav"
        } else if (clickComponent.status == Component.Error) {
            console.log(clickComponent.errorString())
        }

        rootMenuList.currentIndex = 0;
    }

    Keys.onLeftPressed:
        buttonGrid.focusUpperItem()

    Item {
        id: bannerPlaceHolder
        height: banner.height
    }

    ListView {
        id: rootMenuList

        signal itemSelected

        //Oversized fonts being downscaled
        spacing: -30
        focus: true
        keyNavigationWraps: true
        //highlightFollowsCurrentItem: true

        anchors { right: rootMenu.right; top: bannerPlaceHolder.bottom; bottom: buttonGrid.top }

        width: bladeWidth

        model: backend.engines //menuList
        delegate:
            RootMenuListItem { }

        onCurrentIndexChanged: {
            background.role = currentItem.role
            if(menuSoundEffect != undefined) {
                menuSoundEffect.play()
            }
        }

        Keys.onEnterPressed:
            currentItem.trigger()
        Keys.onReturnPressed:
            currentItem.trigger()
        Keys.onRightPressed:
            rootMenu.openSubMenu()
    }

    ButtonList {
        id: buttonGrid
        y: parent.height - height; // # FIXME: Should not access mainBlade
        spacing: 2
        width: parent.width

        onUpperBoundExceeded: {
            rootMenuList.focus = true
        }

        PixmapButton {
            basePixmap: "home-playmedia"
            focusedPixmap: "home-playmedia-FO"
            onClicked: {
                confluence.state = "showingVideoPlayer"
            }
        }
        PixmapButton { basePixmap: "home-favourites"; focusedPixmap: "home-favourites-FO" }
        PixmapButton {
            basePixmap: "home-power";
            focusedPixmap: "home-power-FO";
            onClicked: {
                confluence.selectedElement = exitDialog
                confluence.state = "showingSelectedElement"
            }
        }
    }
}
