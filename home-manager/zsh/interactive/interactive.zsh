# prep: load smartcache plugin
source $ZSH_CONFIG_DIR/plugins/zsh-smartcache/zsh-smartcache.plugin.zsh

autoload -Uz add-zsh-hook

# ‣ [ prompt ]

source $ZSH_CONFIG_DIR/interactive/starship.zsh

# ‣ [ hooks and shell integration ]

# direnv hooks
source $ZSH_CONFIG_DIR/interactive/direnv.zsh

# OSC7: report PWD changes to the terminal emulator
source $ZSH_CONFIG_DIR/interactive/osc7.zsh

# OSC133: mark prompts
source $ZSH_CONFIG_DIR/interactive/osc133.zsh

# notify on command execution
source $ZSH_CONFIG_DIR/interactive/notify.zsh

# ‣ [ completions, aliases and keybindings ]

# here we lazy-load completions by putting initialization into a function
# `init_completions` declared in `$ZSH_CONFIG_DIR/interactive/completion.zsh`.
# on the first execution it will run the initialization, run associated hooks,
# and then `unfunction` itself.

# set some options
fpath+=($XDG_DATA_HOME/zsh/completions)
_comp_options+=(globdots)

# the hooks to be executed when completion initialization is done
# this includes compdef calls, key rebinding, etc
typeset -ga init_completions_hooks=()

# first, make the keymap available to consumers
source $ZSH_CONFIG_DIR/keybindings/keymap_foot.zsh

# define initial bindings and export `bind` function
# we rely on zsh-edit for sane zle widgets so there's a plugin involved too
source $ZSH_CONFIG_DIR/keybindings/keybindings.zsh

# source completions helpers
source $ZSH_CONFIG_DIR/interactive/completion.zsh
# delay completion system initialization until first hit on tab/s-tab
bind tab init_completions

# the hook to run upon completion initialization
_completion_init_hook1 () {
  compdef _files rm
  compdef _lf _lfcd
  compdef _directories mcd
  bind tab fzf_completion
  # actually perform the requested completion
  zle fzf_completion
}
init_completions_hooks+=(_completion_init_hook1)

# load aliases, those which need to use `compdef` will be manually added in a hook
. $ZSH_CONFIG_DIR/interactive/aliases.zsh

# plugins and their keybindings
() {

  local plugin_dir=$ZSH_CONFIG_DIR/plugins

  # autosuggestions
  source $plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(qc-sub-r qc-shell-r)
  ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion history)

  # history substring search
  # ⚠ should come before syntax highlighting
  source $plugin_dir/zsh-history-substring-search/zsh-history-substring-search.zsh
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=black,bg=cyan'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'

  # syntax highlighting
  source $plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
  # faint (dim) and italic rely on ZSH > 5.9, so currently a dev build
  ZSH_HIGHLIGHT_STYLES[comment]='fg=none,faint,italic'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan,italic'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan,italic'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=14,italic,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=13,bold'
  ZSH_HIGHLIGHT_STYLES[command]='fg=11,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=10,bold'

  # fzf-tab
  source $plugin_dir/fzf-tab-completion/fzf-tab-completion.zsh
  zstyle ':completion:*' fzf-search-display true

  # no-ps2
  source $plugin_dir/zsh-no-ps2/zsh-no-ps2.plugin.zsh

  # atuin
  source $plugin_dir/atuin.zsh

}

