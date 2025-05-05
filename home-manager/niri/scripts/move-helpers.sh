#! /bin/sh

set -eu

direction=$1
[ "${2:-}" = "--column" ] && column=true || column=false

focusedFloating=$(niri msg --json focused-window | jq .is_floating)

horizontal () {
  [ "$1" = left ] || [ "$1" = right ]
}

if $focusedFloating; then
  horizontal "$direction" && action="move-column" || action="move-window"
elif $column; then
  horizontal "$direction" && action="move-column" || action="move-column-to-workspace"
else
  horizontal "$direction" && action="swap-window" || action="move-window-$direction-or-to-workspace"
fi

niri msg action "$action-$direction"

