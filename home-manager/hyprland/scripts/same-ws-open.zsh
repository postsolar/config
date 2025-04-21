#! /usr/bin/env zsh
#
# Open a window with initial workspace tracking.
#
#   NB! This is not bash-compatible. Only run it with Zsh.
#
# Arguments:
#   1. Command to run. Will be shell-split.
#   2. App name (window manager class) to match. Specifically, we use Hyprland's `initialClass` parameter to match a window. Must be a valid regexp, escaped if necessary.
#
# Example usage:
# 
#   zsh /path/to/this/script discord discord
#
# will open a Discord window on the workspace this script was executed on.

set -eu

currentWs=$(hyprctl activeworkspace -j | jq .id)

command=$1
appName=$2

setRule () {
  hyprctl keyword windowrule "workspace $currentWs,initialClass:$appName"
}

unsetRule () {
  hyprctl keyword windowrule "workspace unset,initialClass:$appName"
}

handle () {
  if [[ $1 =~ "^openwindow>>\w+,\w+,$appName,.*$" ]]; then
    unsetRule
    exit 0
  fi
}

setRule

$=command >/dev/null 2>&1 &

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
  | while read -r line; do handle "$line"; done

