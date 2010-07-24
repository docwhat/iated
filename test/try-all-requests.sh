#!/bin/bash

set -eu

declare -a curl=(curl -D- -s -S)

function start {
    local msg="${1}"

    echo
    echo "**************************************************"
    echo "Starting: ${1}"
}

function stop {
    echo "**************************************************"
}

function get {
    local url="${1}"
    echo "** get ${url}"
    curl -D- -s -S -f "http://127.0.0.1:9292${url}"
}

function post {
    local url="${1}"
    local data="${2}"
    echo "** post ${url} with '${data}'"
    curl -D- -s -S -f -d "${data}" "http://127.0.0.1:9292${url}"
}

start "/ping test"
get /ping
stop

start "/token test"
get /token
stop

start "/edit POST test"
post /edit/123 "This is a fake document."
stop

start "/edit GET test"
get /edit/123
stop

start "/preferences test"
get /preferences
stop


# EOF
