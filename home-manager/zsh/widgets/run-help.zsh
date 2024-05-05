#! /usr/bin/env zsh

# print the output of `<command> --help` without abandoning
# current editing buffer. `<command>` is the shell word under cursor.

. $ZSH_CONFIG_DIR/widgets/_word-under-cursor.zsh

# zsh doesn't seem to let me override this alias
_run-help () {
  command=$(word-under-cursor)
  print
  ${(z)command} --help
  zle reset-prompt
}
zle -N _run-help

# view the manpage for a command

run-man () zle run-help
zle -N run-man

