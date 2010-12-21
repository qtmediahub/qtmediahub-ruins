import QtQuick 1.0
import "../components/"

Blade {
    id: pictureOptions
    clip: false

    bladeWidth: banner.x + banner.width + 50
    bladePixmap: themeResourcePath + "/media/HomeBlade.png"

    hoverEnabled: true
    onEntered: state = "open"
    onExited: state = "closed"

    resources: ListModel {
        // FIXME: Cannot qsTr() the values of ListElement. We need the equivalent of QT_TRANSLATE_NOOP
        id: optionsModel
        ListElement { name: "VIEW"; options: "LIST,BIG LIST,THUMBNAIL,PIC THUMBS,IMAGE WRAP"; currentOption: 0} // cannot assign js array :/
        ListElement { name: "SORT BY"; options: "NAME,SIZE,DATE"; currentOption: 0}
        ListElement { name: "SLIDESHOW" }
    }

    content: Column {
        anchors.fill: parent
        anchors.topMargin: 50
        anchors.leftMargin: closedBladePeek + 5
        anchors.rightMargin: 5
        spacing: 10

        Image {
            id: banner
            source: themeResourcePath + "/media/Confluence_Logo.png"
        }
        
        ConfluenceListView2 {
            id: listView
            width: parent.width
            height: parent.height - banner.height
            model: optionsModel
        }
    }
}

