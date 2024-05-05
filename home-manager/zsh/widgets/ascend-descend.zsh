#! /usr/bin/env zsh

# change cwd without typing commands

# go to parent directory
ascend () {
  cd ..
  zle reset-prompt
}

# choose from child directories
descend () {
  local fzfOpts=(
    +m
    --read0
    --scheme=path
    --tiebreak=length
    --height=50%
  )
  # for some reason the builtin walker doesn't work within ZLE;
  # falling back to `fd` instead
  d=${ fd . -td -HL0 | fzf $^fzfOpts }
  [[ -z $d ]] || cd -- $d
  zle reset-prompt
}

zle -N ascend
zle -N descend

