#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cd ..

# This script boots up 3 nodes and has them connect to each other
# node1 uses ~/.elosys1 @ 9032
# node2 uses ~/.elosys2 @ 9033; connects to node1
# node3 uses ~/.elosys3 @ 9034; connects to node2

if [ ! "$(command -v "osascript")" ]; then
  echo 'Your computer does not have osascript (Apple Script) installed'
  exit 1
fi

rm -rf ~/.elosys1/databases
rm -rf ~/.elosys2/databases
rm -rf ~/.elosys3/databases

CWD="$(pwd)"
NODE1="yarn start start -v -p 9034 -n peer1 -b localhost:9033 --datadir ~/.elosys1"
NODE2="yarn start start -v -p 9035 -n peer2 -b localhost:9033 --datadir ~/.elosys2 --no-listen"
NODE3="yarn start start -v -p 9036 -n peer3 -b localhost:9033 --datadir ~/.elosys3 --no-listen"
NODE2_LIST="yarn start peers:list -fenas --datadir ~/.elosys1"

osascript <<END
  tell application "Terminal"
    activate
    do script "cd $CWD && $NODE1" in selected tab of the front window
    delay 0.5
    activate
  end tell

  tell application "System Events"
    tell process "Terminal" to keystroke "t" using command down
  end tell

  tell application "Terminal"
    do script "cd $CWD && $NODE2" in selected tab of the front window
    delay 0.5
    activate
  end tell

  tell application "System Events"
    tell process "Terminal" to keystroke "t" using command down
  end tell

  tell application "Terminal"
    activate
    do script "cd $CWD && $NODE3" in selected tab of the front window
    delay 0.5
    activate
  end tell

  tell application "System Events"
    tell process "Terminal" to keystroke "t" using command down
  end tell

  tell application "Terminal"
    activate
    do script "cd $CWD && $NODE2_LIST" in selected tab of the front window
  end tell
END
