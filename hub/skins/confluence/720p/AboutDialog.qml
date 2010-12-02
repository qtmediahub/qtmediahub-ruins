import QtQuick 1.0
import "components"

Dialog {
    id: root
    Engine { name: qsTr("About"); role: "about"; visualElement: root; }
}
