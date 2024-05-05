#! /usr/bin/env zsh

set -e

target=$1
action=$2
amount=$3

go () {
  [[ $action = add ]] || amount=-$amount
  hyprctl -j getoption general:gaps_$1 \
    | fx '.custom.split(" ").map(x => parseInt(x) + '$amount')' list \
    | xargs hyprctl keyword general:gaps_$1
  hyprctl dispatch forcerendererreload
}

case $target in
  inner) go in ;;
  outer) go out ;;
esac >/dev/null

