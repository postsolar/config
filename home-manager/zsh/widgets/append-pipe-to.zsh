#! /usr/bin/env zsh

# widgets which add `| <command>` to the end of the line

# boilerplatey but i found no easy way to emulate a closure

append-pipe-to-fzf () { RBUFFER="$RBUFFER | fzf" }
append-pipe-to-hx () { RBUFFER="$RBUFFER | hx" }
append-pipe-to-editor () { RBUFFER="$RBUFFER | $EDITOR" }
append-pipe-to-wl-copy-primary () { RBUFFER="$RBUFFER | wl-copy -p -n" }
append-pipe-to-wl-copy-clipboard () { RBUFFER="$RBUFFER | wl-copy -n" }

zle -N append-pipe-to-fzf
zle -N append-pipe-to-hx
zle -N append-pipe-to-editor
zle -N append-pipe-to-wl-copy-primary
zle -N append-pipe-to-wl-copy-clipboard

