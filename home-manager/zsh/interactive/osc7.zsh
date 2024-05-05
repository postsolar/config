# OSC for setting terminal emulator's PWD

autoload -Uz add-zsh-hook

osc7-pwd() {
  emulate -L zsh # also sets localoptions for us
  setopt localoptions extendedglob
  local LC_ALL=C
  printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

chpwd-osc7-pwd () {
  (( ZSH_SUBSHELL )) || osc7-pwd
}

add-zsh-hook -Uz chpwd chpwd-osc7-pwd

