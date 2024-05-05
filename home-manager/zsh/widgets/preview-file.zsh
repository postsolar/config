#! /usr/bin/zsh

# preview the file under cursor
#
# the command to preview the file is `${(z)previewFileOpener}` if
# it is set and non-empty, otherwise `$EDITOR --`
# if `$previewFileOpener` is set, it gets passed the filename
# if it's not set, the previewer command is `$EDITOR -- $filename`

. $ZSH_CONFIG_DIR/widgets/_word-under-cursor.zsh

preview-file () {
  local word=$(word-under-cursor)
  previewCommand=${previewFileOpener:-$EDITOR --}
  [[ -z "$word" ]] || ${(z)previewCommand} $word
}

zle -N preview-file

