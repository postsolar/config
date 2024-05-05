#! /usr/bin/env zsh

set -eux

direction=$1

delta=10

active=(${ hyprctl activewindow -j | fx '[x.address, x.floating]' list })
address=$active[1]
floating=$active[2]

# if the first argument to a dispatcher is a negative number,
# hyprctl parses it as an argument to itself, not to the dispatcher.
# since a move left would require arguments `-px px,...`, this
# has to be handled via a different dispatcher
handleMoveLeft () {
  coords=${ hyprctl activewindow -j | fx .at '`${x[0] - '$delta'} ${x[1]}`' }
  hyprctl dispatch movewindowpixel "exact $coords,address:$address"
  exit
}

if $floating; then
  case $direction in
    l|left)  handleMoveLeft ;;
    r|right) resizeparams="$delta 0" ;;
    u|up)    resizeparams="0 -$delta" ;;
    d|down)  resizeparams="0 $delta" ;;
  esac
  hyprctl dispatch movewindowpixel "$resizeparams,address:$address"
else
  hyprctl dispatch hy3:movewindow $direction,once,visible
fi

