#!/usr/bin/env bash
#
# This script is part of the SPB project : https://github.com/henri/spb
# (C) 2026 Henri Shustak - Released Under the GNU GPL v3 or later
#
# Example script to launch a new brave instance with SPB and update the componets
# and make some configuration alterations using the remote debging port.
#
# This script will accept parameters and pass them to SPB. Below is an example
# to start this scirpt and create a new standard template called testing12 with 
# updated componets and updated settings applied automatically
#
# ~/bin/brave-new.bash --new-template testing12 --standard --no-first-run
#
# On macOS install gshuf via coreutils and then replace shuf with gshuf
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
    ! ss -tulpn | grep -q ":$CDP_PORT " && break
done
BASE="http://localhost:$CDP_PORT"

# start browser (via command spb)
ADDITIONAL_SPB_ARGS="$@"
fish -c "spb $ADDITIONAL_SPB_ARGS --remote-debugging-port=$CDP_PORT"
if [[ $? != 0 ]] ; then
    echo "ERROR! : Failed to start Brave via SPB."
    echo ""
    exit -9
fi
echo "Started brave instance with CDP port number : $CDP_PORT"
# sleep 1.45


# function to assist with requests
cdp() {
    echo "$1" | websocat -n1 "$WS_URL" 2>/dev/null || true
}
cdp_silent() {
    echo "$1" | websocat -n1 "$WS_URL" > /dev/null 2>&1 || true
}
cdp_send() {
  local ws="$1" payload="$2"
  echo "$payload" | websocat "$ws" | head -1 > /dev/null
}
set_pref() {
  local ws="$1" pref="$2" value="$3"
  local id=$(( RANDOM % 1000 + 1 ))
  cdp_send "$ws" \
    "{\"id\":$id,\"method\":\"Runtime.evaluate\",\"params\":{\"expression\":\"chrome.settingsPrivate.setPref(\\\"$pref\\\",$value,undefined,function(r){console.log(r)})\",\"awaitPromise\":true}}"
}
SPINNER=0
spinner() {
    local sp='/-\|'
    local n=${#sp}
    tput civis
    printf '%s\b' "${sp:$(( SPINNER++ % n )):1}"
}
spinner_delete() {
    printf ' \b'
    tput cnorm
    echo ""
}
spinner_sleep() {
    for i in $(seq 1 30) ; do
        spinner
        sleep 0.1
    done
    #sleep 3
}

echo -n "Waiting for Brave CDP on port $CDP_PORT..."
for i in $(seq 1 30) ; do
    spinner
    sleep 0.1 ; spinner ;sleep 0.1 ; spinner
    if curl -sf "http://localhost:${CDP_PORT}/json/version" > /dev/null 2>&1; then
        spinner
        spinner_delete
        break
    fi
    if [[ $i -eq 30 ]]; then
        echo "" ; echo ""
        echo -e "ERROR! : Brave not reachable on port $CDP_PORT after 5 attempts."
        echo "            Check it running with --remote-debugging-port=$CDP_PORT"
        echo ""
        exit 1
    fi
    
done


##### update compoents
echo -n "Updating Brave Components..."

curl -sf "http://localhost:${CDP_PORT}/json/version" > /dev/null \
    || { echo "brave is not reachable on port $CDP_PORT. Check it running with --remote-debugging-port=$CDP_PORT?"; exit 1; }

# open new tab (or likley a window if private browing enabled)
NEW_TAB=$(curl -sf -X PUT "http://localhost:${CDP_PORT}/json/new")
WS_URL=$(echo "$NEW_TAB" | jq -r '.webSocketDebuggerUrl')
TARGET_ID=$(echo "$NEW_TAB" | jq -r '.id')

if [[ -z "$WS_URL" || "$WS_URL" == "null" ]]; then
    echo ""
    echo "ERROR! : Failed to open a new tab."
    echo ""
    exit 1
fi

# open compoents window (from which we will run updates)
cdp_silent '{"id":1,"method":"Page.navigate","params":{"url":"brave://components/"}}'
spinner_sleep

# count the buttons we can click update
COUNT_RESULT=$(cdp '{"id":2,"method":"Runtime.evaluate","params":{"expression":"document.querySelectorAll(\"button\").length","returnByValue":true}}')
COUNT=$(echo "$COUNT_RESULT" | jq -r '.result.result.value // 0')

# click each button to update the compoent
for ((i=0; i<COUNT; i++)); do
    ID=$((i + 10))
    # echo -n "."
    sleep 0.1 ; spinner sleep 0.1 ; spinner
    cdp_silent "{\"id\":$ID,\"method\":\"Runtime.evaluate\",\"params\":{\"expression\":\"document.querySelectorAll('button')[$i].click()\",\"returnByValue\":true}}"
    sleep 0.1 ; spinner
done

# everything updated close the compoents window / tab
curl -sf -X GET "http://localhost:${CDP_PORT}/json/close/${TARGET_ID}" > /dev/null
spinner
spinner_delete

###### setup browser options
echo "Configuring Brave Settings..."

# open settings tab
WS=$(curl -s -X PUT "$BASE/json/new?brave://settings/appearance" \
  | jq -r '.webSocketDebuggerUrl')

# apply preferences
set_pref "$WS" "brave.tabs.vertical_tabs_enabled"                        "true"
set_pref "$WS" "brave.tabs.vertical_tabs_hide_completely_when_collapsed" "true"

# close settings tab
ID=$(curl -s "$BASE/json" | jq -r '.[0].id')
curl -s -X GET "$BASE/json/close/$ID" > /dev/null

