#! /usr/bin/env sh

cursorPos=$(hyprctl cursorpos)
eval "$@"
hyprctl dispatch movecursor ${cursorPos/,/}
