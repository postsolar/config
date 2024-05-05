() {

  # TODO: remove history handling since it's managed by atuin

  WORDCHARS=''
  PROMPT_EOL_MARK='%F{8}%f'
  # HISTFILE=$ZSH_CONFIG_DIR/cache/commands_history
  # SAVEHIST=50000
  # HISTSIZE=50000

  local optsUnset=(
    autolist
    # hist_ignore_dups
  )
  unsetopt $^optsUnset

  local optsSet=(
    # other
    notify auto_continue interactive_comments prompt_subst

    # sadly, very little works with no_unset
    unset

    # directories / navigation
    autocd cdable_vars no_cd_silent chase_links

    # completions
    correct correctall
    automenu auto_param_slash glob_complete menu_complete

    # extra globs settings
    glob_star_short
    equals

    # history
    # inc_append_history
    # bang_hist
    # extended_history
    # hist_ignore_space
    # hist_ignore_all_dups
    # hist_save_no_dups
    # hist_expire_dups_first
    # hist_find_no_dups
    # hist_reduce_blanks
    # share_history
    # hist_verify
    # hist_lex_words
  )
  setopt $^optsSet

  zstyle ':completion:*' menu select
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*' cache-path $ZSH_CACHE_DIR/zcompcache
  zstyle ':completion:*' complete-options true
  zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
  zstyle ':completion:*' insert-unambiguous true
  zstyle ':completion:*' list-colors ''
  zstyle ':completion:*' matcher-list '+m:{[:lower:]}={[:upper:]} r:|[./]=** r:|=**' '+m:{[:lower:]}={[:upper:]} r:|[./]=** r:|=** l:|=*' '+m:{[:lower:]}={[:upper:]} r:|[./]=** r:|=** l:|=*' '+m:{[:lower:]}={[:upper:]} r:|[./]=** r:|=** l:|=*'
  # zstyle ':completion:*' match-original both
  # zstyle ':completion:*' max-errors 2
  # zstyle ':completion:*' original false
  zstyle ':completion:*' verbose true

}

