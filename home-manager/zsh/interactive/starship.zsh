if [[ -v commands[starship] ]]; then

  # could use smartcache here but it's a few ms slower
  if [[ -r $ZSH_CACHE_DIR/starship-init.zsh.zwc ]]; then
    source $ZSH_CACHE_DIR/starship-init.zsh
  else
    starship init zsh --print-full-init > $ZSH_CACHE_DIR/starship-init.zsh
    source $ZSH_CACHE_DIR/starship-init.zsh
    zcompile -- $ZSH_CACHE_DIR/starship-init.zsh &!
  fi

fi

