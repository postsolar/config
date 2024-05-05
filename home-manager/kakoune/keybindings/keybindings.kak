# erase some default keybinds
evaluate-commands %sh{ $kak_config/keybindings/unmap.zsh }

# ----- Options ---------------------------------------------------------------

set-option global indentwidth 2
set-option global disabled_hooks .*-indent

# ----- Normal mode -----------------------------------------------------------

# buffers
map global normal <tab> ":buffer-next<ret>"
map global normal <s-tab> ":buffer-previous<ret>"

# trivial modifications
map global normal '#' ":comment-line<ret>"
map global normal '<a-#>' ":comment-block<ret>"

# movement
# word-wise
map global normal q b
map global normal <s-q> <s-b>
map global normal <a-q> <a-b>
map global normal <a-s-q> <a-s-b>
map global normal f e
map global normal <s-f> <s-e>
map global normal <a-f> <a-e>
map global normal <a-s-f> <a-s-e>

# char/line-wise
# consideration: make it do what (a-)(s-)m does instead?
map global normal <a-left> <a-h>
map global normal <a-right> <a-l>

map global normal <s-pageup> "Z<pageup><a-z>u<a-;><a-;>"
map global normal <s-pagedown> "Z<pagedown><a-z>u<a-;><a-;>"

map global normal p "]p"
map global normal <s-p> "}p"
map global normal <a-p> "[p"
map global normal <a-s-p> "{p"

map global normal e f
map global normal <s-e> <s-f>
map global normal <a-e> <a-f>
map global normal <a-s-e> <a-s-f>

# selections
map global normal <a-:> <a-semicolon>

try %{
  require-module byline
  map global normal x ":byline-expand-below<ret>"
  map global normal X ":byline-expand-above<ret>"
}

# copy / paste / replace

map global normal z p
map global normal <s-z> <s-p>

# insert mode entries
map global normal c     ':try "exec _"<ret>c'
map global normal <a-c> ':try "exec _"<ret><a-c>'

# jump list
map global normal l <c-i>
map global normal <s-l> <c-o>
map global normal <a-l> <c-s>

# marks
map global normal h z
map global normal <s-h> <s-z>
map global normal <a-h> <a-z>
map global normal <a-s-h> <a-s-z>

# ----- Goto mode -------------------------------------------------------------
# NOTE docstrings don't automatically get restored,
# they need to be written out manually.

map global goto g i
map global goto s g
map global goto e e
map global goto <s-e> j
map global goto t t
map global goto c c
map global goto b b
map global goto <left> h
map global goto <right> l
map global goto . .
map global goto a a

# files
map global goto f f

# ----- View mode -------------------------------------------------------------

map global view <left>  h
map global view <down>  j
map global view <up>    k
map global view <right> l

# ----- Insert mode -----------------------------------------------------------

# ----- Prompt mode -----------------------------------------------------------

# move
map global prompt <s-left> <a-b>
map global prompt <a-left> <a-s-b>
map global prompt <s-right> <a-f><left>
map global prompt <a-right> <a-s-f><left>

# delete
map global prompt <s-backspace> <c-w>
map global prompt <a-backspace> <c-s-w>
map global prompt <a-s-backspace> <c-u>

map global prompt <s-del> <a-d>
map global prompt <a-del> <a-s-d>
map global prompt <a-s-del> <c-k>

