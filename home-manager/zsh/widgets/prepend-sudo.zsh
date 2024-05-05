#! /usr/bin/env zsh

# fish-inspired widget for prepending sudo to a command

prepend-sudo () {
  sudoCommand=$(
    for c in please doas sudo; do
      if [[ -v commands[$c] || -v functions[$c] || -v aliases[$c] ]];
        then print $c
      fi
    done
  )
  # contrary to intuition, $LBUFFER is the contents of
  # *the line*, rather than of the whole buffer
  LBUFFER="${sudoCommand:+$sudoCommand }$LBUFFER"
}

zle -N prepend-sudo

