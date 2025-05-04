#! /bin/sh

set -eu

column=false

while [ $# -gt 0 ]; do
  case "$1" in
    left|right|up|down)
      direction=$1
      ;;
    --column)
      column=true
      ;;
    *)
      >&2 printf "invalid argument: %s\n" "$1"
      exit 1
  esac
  shift
done

[ -n "${direction-}" ] || {
  >&2 printf "missing argument for direction (left|right|up|down)\n"
  exit 1
}

currFloating=$(niri msg --json focused-window | jq .is_floating)

if $currFloating; then

  if [ "$direction" = left ] || [ "$direction" = right ]; then
    niri msg action move-column-"$direction"
  else
    niri msg action move-window-"$direction"
  fi

elif $column; then

  case "$direction" in
    left|right)
      niri msg action move-column-"$direction"
      ;;
    up|down)
      niri msg action move-column-to-workspace-"$direction"
      ;;
  esac

else

  case "$direction" in
    left|right)
      niri msg action swap-window-"$direction"
      ;;
    up|down)
      niri msg action move-window-"$direction"-or-to-workspace-"$direction"
      ;;
  esac

fi
