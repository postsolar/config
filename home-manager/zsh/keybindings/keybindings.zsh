# ensure we were provided with a keymap beforehand
# still a very weak promise but better than nothing
[[ -v keys ]] || return

# Ref: https://github.com/QuarticCat/dotfiles/blob/aacdabf9dcbb0246b81fd0daf35b5c37d072b37c/zsh/.zshrc#L140-L165
qc-word-widgets() {
  local wordpat='[[:WORD:]]##|[[:space:]]##|[^[:WORD:][:space:]]##'
  local words=(${(Z:n:)BUFFER}) lwords=(${(Z:n:)LBUFFER})
  case $WIDGET {
    (*sub-l)   local move=-${(N)LBUFFER%%$~wordpat} ;;
    (*sub-r)   local move=+${(N)RBUFFER##$~wordpat} ;;
    (*shell-l) local move=-${(N)LBUFFER%$lwords[-1]*} ;;
    (*shell-r) local move=+${(N)RBUFFER#*${${words[$#lwords]#$lwords[-1]}:-$words[$#lwords+1]}} ;;
  }
  case $WIDGET {
    (*kill*) (( MARK = CURSOR + move )); zle -f kill; zle .kill-region ;;
    (*)      (( CURSOR += move )) ;;
  }
}
for w in qc{,-kill}-{sub,shell}-{l,r}; zle -N $w qc-word-widgets
WORDCHARS='*?[]~&;!#$%^(){}<>'

# Trim trailing spaces from pasted text
# Ref: https://github.com/QuarticCat/dotfiles/blob/aacdabf9dcbb0246b81fd0daf35b5c37d072b37c/zsh/.zshrc#L167-L172
qc-trim-paste() {
  zle .$WIDGET && LBUFFER=${LBUFFER%%[[:space:]]#}
}
zle -N bracketed-paste qc-trim-paste

bind () {
  if [[ -v keys[$1] ]]; then
    bindkey -- $keys[$1] $2
  else
    print >&2 "[Warning] attempting to bind unmapped key $1, skipping"
  fi
}

# load some widgets
() {
  local -a widgets=(
    ascend-descend fzf-complete-file fzf-shell-history
    prepend-sudo   append-pipe-to    preview-file
    run-help       list-token
    )
  for widget in $widgets
    source ${ZSH_CONFIG_DIR}/widgets/${widget}.zsh
}

# Exit shell on C-d even when command line isn't empty
exit_zsh () exit
zle -N exit_zsh

# Use LF to navigate directories
_lfcd-widget () { lfcd; zle reset-prompt }
zle -N _lfcd-widget

# Edit the command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line

# for key sequences to trigger instantly (i.e. not work), `escape` specifically
KEYTIMEOUT=10

# remove all existing keybindings
bindkey -rp ''
# for ascii text
bindkey -R ' '-'~' self-insert
# for non-ascii text
bindkey -R "\M-^@"-"\M-^?" self-insert
# for proper pasting
bindkey "^[[200~" bracketed-paste

# TODO maybe just generate it straight with nix?
# print -- /nix/store/2lkwfz0acmjfk56qsrlnzqh4bdikpcv5-zsh-5.9/share/zsh/5.9/functions/Zle/* | fzf
# zle -la | fzf

bind enter          accept-line
bind a-s-enter      autosuggest-execute

# delete
# wish we just had s-backspace
bind backspace      backward-delete-char
bind a-backspace    qc-kill-shell-l
bind c-backspace    qc-kill-sub-l

bind delete         delete-char
bind a-delete       qc-kill-shell-r
bind c-delete       qc-kill-sub-r

bind a-bracketleft  backward-kill-line
bind a-bracketright kill-line
bind a-d            kill-buffer
bind c-l            clear-screen

# move
# TODO add {,s-,c-,a-}right to autosuggest widgets
bind up             atuin-up-search
bind down           down-line-or-history
bind left           backward-char
bind right          forward-char
bind s-left         qc-sub-l
bind s-right        qc-sub-r
bind a-left         qc-shell-l
bind a-right        qc-shell-r
bind c-left         beginning-of-line
bind c-right        end-of-line
bind home           beginning-of-buffer
bind end            end-of-buffer

# complete, prepend, append
bind a-s            prepend-sudo
bind c-t            fzf-complete-file
bind c-r            atuin-search

# navigate short-term history
bind a-u            undo
bind a-s-u          redo
bind a-dot          insert-last-word

# etc
bind a-e            edit-command-line
bind a-space        _lfcd-widget
bind a-up           ascend
bind a-down         descend
bind a-t            transpose-words

