autoload -Uz add-zsh-hook

if [[ -v commands[direnv] ]]; then
  _direnv_hook() {
    trap -- '' SIGINT
    eval ${ direnv export zsh }
    trap - SIGINT
  }
  add-zsh-hook precmd _direnv_hook
  add-zsh-hook chpwd _direnv_hook
fi

