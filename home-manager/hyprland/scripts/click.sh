#! /usr/bin/env sh

# click with wl-kbptr floating mode and bring back cursor to where it was originally

cursorPos=$(hyprctl cursorpos)
wl-kbptr -o modes=floating,click -o mode_floating.source=detect
hyprctl dispatch movecursor ${cursorPos/,/}
