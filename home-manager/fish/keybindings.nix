{ ... }:

{
  programs.fish.functions.fish_user_key_bindings = # fish
    ''
    bind --erase --all
    bind --preset --erase --all

    # ~ trivial ones

    bind escape cancel
    bind ctrl-d exit

    bind ${ "''" } self-insert
    bind enter execute
    bind shift-enter 'commandline -i \\n'

    # ~ pager

    bind tab complete
    bind shift-tab complete-and-search
    bind alt-/ pager-toggle-search

    # ~ movement

    bind down down-or-search
    bind up up-or-search

    bind left backward-char
    bind shift-left backward-token
    bind alt-left backward-word
    bind alt-shift-left backward-bigword
    bind home beginning-of-line
    bind alt-\< beginning-of-buffer

    bind right forward-char
    bind shift-right forward-token
    # bind alt-right forward-word
    bind alt-right forward-word forward-single-char
    bind alt-shift-right forward-bigword
    bind end end-of-line
    bind alt-\> end-of-buffer

    # ~ erasing

    bind backspace backward-delete-char
    bind shift-backspace backward-kill-token
    bind alt-backspace backward-kill-word
    bind alt-shift-backspace backward-kill-bigword
    bind alt-d kill-line
    bind alt-shift-d kill-whole-line
    bind alt-c clear-commandline

    bind ctrl-l clear-screen

    bind alt-u undo
    bind alt-shift-u redo

    # ~ misc

    bind alt-t transpose-words
    bind alt-e edit_command_buffer
    bind shift-up history-token-search-backward
    bind shift-down history-token-search-forward
    bind alt-s 'fish_commandline_prepend sudo'
    bind ctrl-z 'jobs -q && fg; commandline -f repaint'

    bind ctrl-t fzf-file-widget
    bind ctrl-r _atuin_search
    bind alt-up "builtin cd ..; commandline -f repaint"
    bind alt-down fzf-cd-widget
    bind alt-a hx
    bind alt-i _aichat_fish
    '';
}

