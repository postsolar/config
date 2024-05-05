#! /usr/bin/env zsh

# insert a command from command history into command line

fzf-shell-history () {
  if [[ -v commands[zat] ]]; then
    local -r catOrZat='zat -l bash'
  else
    local -r catOrZat='cat'
  fi

  # the extra `print --` here is so that the output gets formatted, e.g. `\n`'s etc
  local cmd=${
    print -- ${
      fc -rln 1 \
        | fzf --scheme=history --preview "printf '%b\n' {} | $catOrZat"
    }}

  if [[ -n "$cmd" ]]; then
    LBUFFER=$cmd
  fi
  zle reset-prompt
}

zle -N fzf-shell-history

