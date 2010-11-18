import QtQuick 1.0
import QMHPlugin 1.0

QMHPlugin {
    id: engine
    Component.onCompleted:
        backend.registerEngine(engine)
}
