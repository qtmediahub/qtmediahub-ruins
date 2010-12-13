import QtQuick 1.0
import "util.js" as Util
import "components"

// We explicitly want to build the model in the QML since we want to the view
// to entirely control the display of information. 
// Future work:
// 1. A live map showing geolocation

Sheet {
    property variant currentItem
    width: 600
    title: qsTr("Picture Information")

    resources : ListModel {
        id: listModel
    }

    onCurrentItemChanged : {
        listModel.clear()
        var item = currentItem.itemdata
        // First add items that are guaranteed to be present
        listModel.append({key: qsTr("File name"), value: item.fileName})
        listModel.append({key: qsTr("File path"), value: item.filePath})
        listModel.append({key: qsTr("File size"), value: Util.toHumanReadableBytes(item.fileSize)})
        listModel.append({key: qsTr("File date/time"), value: item.fileDateTime})
        listModel.append({key: qsTr("Resolution"), value: item.resolution.width + 'x' + item.resolution.height})
        // Exif information may or may not be present
        var translations = { // FIXME: make global
            "userComments" : qsTr("User comments"),
            "imageDescription" : qsTr("Image description"),
            "creationTime" : qsTr("Creation time"),
            "cameraModel" : qsTr("Camera model"),
            "cameraMake" : qsTr("Camera make"),
            "latitude" : qsTr("Latitude"),
            "longitude" : qsTr("Longitude"),
            "altitude" : qsTr("Altitude"),
            "orientation" : qsTr("Orientation"),
            "aperture" : qsTr("Aperture"),
            "focalLength" : qsTr("Focal length"),
            "exposureMode" : qsTr("Exposure Mode"),
            "whiteBalance" : qsTr("White Balance"),
            "lightSource" : qsTr("Light Source"),
            "isoSpeed" : qsTr("ISO"),
            "digitalZoomRatio" : qsTr("Digital Zoom"),
            "flashUsage" : qsTr("Flash Usage"),
            "exposureTime" : qsTr("Exposure Time"),
            "colorSpace" : qsTr("Colour/B&W")
        }
        for (var k in item.exifProperties) {
            var v = item.exifProperties[k];
            if (v == "" || !(k in translations))
                continue;
            listModel.append({key: translations[k], value: v})
        }
                           }

    ConfluenceListView {
        id: listView
        anchors.fill: parent
        model : listModel

        delegate: ConfluenceTwoColumnDelegate {
            column1Text: model.key
            column2Text: model.value
        }
    }
}

