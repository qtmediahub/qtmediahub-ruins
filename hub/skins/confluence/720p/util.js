.pragma library

function toHumanReadableBytes(bytes)
{
    var suffixes = [ 'bytes', 'KB', 'MB', 'TB' ] // qsTr?
    var idx = 0
    while (bytes > 1024 && idx < 3) {
        bytes /= 1024
        ++idx
    }
    return bytes.toFixed(2) + ' ' + suffixes[idx]
}

