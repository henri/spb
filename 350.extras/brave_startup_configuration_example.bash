#!/usr/bin/env bash
#
# This script is part of the SPB project : https://github.com/henri/spb
# (C) 2026 Henri Shustak - Released Under the GNU GPL v3 or later
#
# Example script to launch a new Brave session with spb and configure hidden virticle tabs
# 
# This script is aimed to provide an idea about what is possibe
# 
# This script is not production ready it is dirty script with zero error checking.
#
# Assumes you have jq. websocat and other tools installed on your system
#
# The idea is for this to be a template to build what you would like to setup
#
# On macOS install gshuf via coreutils and then replace shuf with gshuf
#



# pick random port
while true; do
    PORT=$(shuf -i 9000-9999 -n 1)
    ! ss -tulpn | grep -q ":$PORT " && break
done
BASE="http://localhost:$PORT"

# send debugging payload to websocket with websocat
cdp_send() {
  local ws="$1" payload="$2"
  echo "$payload" | websocat "$ws" | head -1 > /dev/null
}

# set prefernces function
set_pref() {
  local ws="$1" pref="$2" value="$3"
  local id=$(( RANDOM % 1000 + 1 ))
  cdp_send "$ws" \
    "{\"id\":$id,\"method\":\"Runtime.evaluate\",\"params\":{\"expression\":\"chrome.settingsPrivate.setPref(\\\"$pref\\\",$value,undefined,function(r){console.log(r)})\",\"awaitPromise\":true}}"
}

# start browser
fish -c "spb --remote-debugging-port=$PORT"
sleep 2

# open settings tab
WS=$(curl -s -X PUT "$BASE/json/new?brave://settings/appearance" \
  | jq -r '.webSocketDebuggerUrl')

# apply preferences
set_pref "$WS" "brave.tabs.vertical_tabs_enabled"                        "true"
set_pref "$WS" "brave.tabs.vertical_tabs_hide_completely_when_collapsed" "true"

# close settings tab
ID=$(curl -s "$BASE/json" | jq -r '.[0].id')
curl -s -X GET "$BASE/json/close/$ID" > /dev/null
