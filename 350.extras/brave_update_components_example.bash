#!/usr/bin/env bash
#
# This script is part of the SPB project : https://github.com/henri/spb
# (C) 2026 Henri Shustak - Released Under the GNU GPL v3 or later
#
# Example script to launch a new brave instance with SPB and update the componets
# on that launched isolated instance.
# 
# This script is aimed at provide an idea about how to setup a browser with with
# updated compoents.
# 
# This script is not production ready it is dirty script with very low error checking.
#
# Assumes you have cur, jq. websocat and other tools installed on your system
#
# The idea is for this to be a template to build what you would like to setup
#


os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$os_type" == "darwin" ]] ; then SHUF="gshuf" ; else SHUF="shuf" ; fi


# preflight checks for required components 
for cmd in curl jq websocat; do
    command -v "$cmd" &>/dev/null || { echo "missing: $cmd"; exit 1; }
done

# pick random port
while true; do
    CDP_PORT=$(shuf -i 9000-9999 -n 1)
    if [[ "$os_type" == "darwin" ]] ; then 
        ! lsof -iTCP:"$CDP_PORT" -sTCP:LISTEN >/dev/null 2>&1 && break
    else
        ! ss -tulpn | grep -q ":$CDP_PORT " && break
    fi
done

# start browser (via command spb)
fish -c "spb --remote-debugging-port=$CDP_PORT"
echo "Started brave instance with CDP port number : $CDP_PORT"
sleep 1.45

echo "Waiting for Brave on port $CDP_PORT..."
for i in $(seq 1 10); do
    if curl -sf "http://localhost:${CDP_PORT}/json/version" > /dev/null 2>&1; then
        echo "CDP ready."
        break
    fi
    if [[ $i -eq 10 ]]; then
        echo "Brave not reachable on port $CDP_PORT after 10 attempts. Is it running with --remote-debugging-port=$CDP_PORT?"
        exit 1
    fi
    echo "  Attempt $i/10 failed, retrying..."
    sleep 1
done

curl -sf "http://localhost:${CDP_PORT}/json/version" > /dev/null \
    || { echo "brave is not reachable on port $CDP_PORT. Check it running with --remote-debugging-port=$CDP_PORT?"; exit 1; }

# open new tab (or likley a window if private browing enabled)
NEW_TAB=$(curl -sf -X PUT "http://localhost:${CDP_PORT}/json/new")
WS_URL=$(echo "$NEW_TAB" | jq -r '.webSocketDebuggerUrl')
TARGET_ID=$(echo "$NEW_TAB" | jq -r '.id')

if [[ -z "$WS_URL" || "$WS_URL" == "null" ]]; then
    echo "Failed to open a new tab."
    exit 1
fi

# function to assist with requests
cdp() {
    echo "$1" | websocat -n1 "$WS_URL" 2>/dev/null || true
}

cdp_silent() {
    echo "$1" | websocat -n1 "$WS_URL" > /dev/null 2>&1 || true
}

# open compoents window (from which we will run updates)
cdp_silent '{"id":1,"method":"Page.navigate","params":{"url":"brave://components/"}}'
sleep 3

# count the buttons we can click update
COUNT_RESULT=$(cdp '{"id":2,"method":"Runtime.evaluate","params":{"expression":"document.querySelectorAll(\"button\").length","returnByValue":true}}')
COUNT=$(echo "$COUNT_RESULT" | jq -r '.result.result.value // 0')

# click each button to update the compoent
for ((i=0; i<COUNT; i++)); do
    ID=$((i + 10))
    cdp_silent "{\"id\":$ID,\"method\":\"Runtime.evaluate\",\"params\":{\"expression\":\"document.querySelectorAll('button')[$i].click()\",\"returnByValue\":true}}"
    sleep 0.3
done

# everything updated close the compoents window / tab
curl -sf -X GET "http://localhost:${CDP_PORT}/json/close/${TARGET_ID}" > /dev/null


