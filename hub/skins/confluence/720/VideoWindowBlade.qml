import QtQuick 1.0
import "../components/"

Blade {
    id: videoOptions
    clip: false

    signal viewChanged(string viewType)
    signal sortOrderChanged(string sortOrderType)
    signal slideShowClicked()

    bladeWidth: banner.x + banner.width + 50
    bladePixmap: themeResourcePath + "/media/HomeBlade.png"

    hoverEnabled: true
    onEntered: state = "open"
    onExited: state = "closed"

    resources: ListModel {
        // FIXME: Cannot qsTr() the values of ListElement. We need the equivalent of QT_TRANSLATE_NOOP
        id: optionsModel
        ListElement { name: "VIEW"; type: "view"; options: "LIST,BIG LIST,THUMBNAIL,PIC THUMBS,IMAGE WRAP,POSTER"; currentOption: 0} // cannot assign js array :/
        ListElement { name: "SORT BY"; type: "sort"; options: "NAME,SIZE,DATE"; currentOption: 0}
        ListElement { name: "SLIDESHOW"; type: "slideshow" }
    }

    content: Column {
        anchors.fill: parent
        anchors.topMargin: 50
        anchors.leftMargin: closedBladePeek + 5
        anchors.rightMargin: 5

        Image {
            id: banner
            source: themeResourcePath + "/media/Confluence_Logo.png"
            anchors.bottomMargin: 10
        }
        
        ConfluenceListView2 {
            id: listView
            width: parent.width
            height: parent.height - banner.height
            model: optionsModel
            onActivated: {
                if (item.modeldata.type == "view")
                    videoOptions.viewChanged(item.modeldata.options.split(",")[item.modeldata.currentOption])
                else if (item.modeldata.type == "sort")
                    videoOptions.sortOrderChanged(item.modeldata.options.split(",")[item.modeldata.currentOption])
                else if (item.modeldata.type == "slideshow")
                    videoOptions.slideShowClicked()
            }
        }
    }
}

