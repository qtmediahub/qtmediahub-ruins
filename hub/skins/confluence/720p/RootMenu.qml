import QtQuick 1.0
import "components"


FocusScope {
    id: rootMenu
    height: parent.height; width: parent.width

    property variant menuSoundEffect
    property string name: "rootmenu"

    Component.onCompleted: {
        var clickComponent = Qt.createComponent("components/QMHAudio.qml");
        if(clickComponent.status == Component.Ready) {
            menuSoundEffect = clickComponent.createObject(mainBlade)
            menuSoundEffect.source = themeResourcePath + "/sounds/click.wav"
        } else if (clickComponent.status == Component.Error) {
            console.log(clickComponent.errorString())
        }
    }

    Keys.onLeftPressed:
        buttonGrid.focusUpperItem()

    Item {
        id: bannerPlaceHolder
        height: banner.height
    }

    ListView {
        id: mainBladeList

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
            BladeListItem { }

        onItemSelected: {
            background.asyncSetRole(currentItem.role)
            if(menuSoundEffect != undefined) {
                menuSoundEffect.play()
            }
        }

        Keys.onEnterPressed:
            currentItem.trigger()
        Keys.onReturnPressed:
            currentItem.trigger()
        Keys.onRightPressed: {
            if(currentItem.hasSubBlade) {
                mainBlade.subMenu.state = "open";
                // not really nice should be also a property of the currentItem, but I don't know how to add a QList<QObject*> property
                mainBlade.subMenuList.model = backend.engines[currentIndex].childItems;
            }
        }
    }

    ButtonList {
        id: buttonGrid
        x: mainBlade.bladeX + 5 + bladeRightMargin; y: parent.height - height;
        spacing: 2
        width: parent.width

        onUpperBoundExceeded: {
            mainBladeList.focus = true
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
