#!/usr/bin/env bash
_writeLog() {
    m=$1
    echo ":: $m"
}

_majorLog() {
    m=$1
    echo "  ==> $m"
}

_minorLog() {
    m=$1
    echo "  -> $m"
}

_cmdExists() {
    return command -v $1 >/dev/null 2>&1
}
