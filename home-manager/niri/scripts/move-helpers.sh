#! /bin/sh

set -eu

direction=$1
[ "${2:-}" = "--column" ] && column=true || column=false

currFloating=$(niri msg --json focused-window | jq .is_floating)

horizontal () {
  case "$1" in
    left|right) return 0 ;;
    up|down) return 1
  esac
}

if $currFloating; then
  horizontal "$direction" && action="move-column-$direction" || action="move-window-$direction"
elif $column; then
  horizontal "$direction" && action="move-column-$direction" || action="move-column-to-workspace-$direction"
else
  horizontal "$direction" && action="swap-window-$direction" || action="move-window-$direction-or-to-workspace-$direction"
fi

niri msg action "$action"

