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

function ms2string(ms)
{
    var ret = "";

    if (ms == 0)
        return "00:00:00";

    var h = (ms/(1000*60*60)).toFixed(0);
    var m = ((ms%(1000*60*60))/(1000*60)).toFixed(0);
    var s = (((ms%(1000*60*60))%(1000*60))/1000).toFixed(0);

    if (h >= 1) {
        ret += h < 10 ? "0" + h : h + "";
        ret += ":";
    }

    ret += m < 10 ? "0" + m : m + "";
    ret += ":";
    ret += s < 10 ? "0" + s : s + "";

    return ret;
}
