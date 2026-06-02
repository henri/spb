#!/usr/bin/env bash

#
# Example script to launch a new Brave session with spb and configure hidden virticle tabs
# 
# This script is aimed to provide an idea about what is possibe
# 
# This script is not production ready it is dirty script with zero error checking.
#
# Assumes you have jq and other tools installed on your system
#
# The idea is for this to be a template to build what you would like to setup
#


# pick random port
while true; do
    PORT=$(shuf -i 9000-9999 -n 1)
    ! ss -tulpn | grep -q ":$PORT " && break
done

# start a new browser 
fish -c "spb --remote-debugging-port=$PORT"
sleep 2

# get the web socket URL
WS=$(curl -s http://localhost:$PORT/json | jq -r '.[0].webSocketDebuggerUrl')

# open new normal tab and get its WebSocket URL
WS=$(curl -s -X PUT "http://localhost:$PORT/json/new?brave://settings/appearance" | jq -r '.webSocketDebuggerUrl')

# set virticle tabs
echo '{"id":2,"method":"Runtime.evaluate","params":{"expression":"chrome.settingsPrivate.setPref(\"brave.tabs.vertical_tabs_enabled\",true,undefined,function(r){console.log(r)})"}}' | websocat "$WS" | head -1 > /dev/null

# set collapsed
echo '{"id":5,"method":"Runtime.evaluate","params":{"expression":"chrome.settingsPrivate.setPref(\"brave.tabs.vertical_tabs_hide_completely_when_collapsed\",true,undefined,function(r){console.log(r)})","awaitPromise":true}}' | websocat "$WS" | head -1 > /dev/null

# close window
ID=$(curl -s http://localhost:$PORT/json | jq -r '.[0].id')
curl -s -X GET "http://localhost:$PORT/json/close/$ID" > /dev/null
