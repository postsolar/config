#! /usr/bin/env zsh

set -eu

typeset -A kws=(inner general:gaps_in outer general:gaps_out)

go () {
  hyprctl -j getoption $1 \
    | fx '.custom.split(" ")' "@parseInt(x) + $2" list \
    | xargs hyprctl keyword $1
}

go $kws[$1] $2
