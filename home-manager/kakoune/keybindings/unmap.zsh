#! /usr/bin/env zsh

# goto mode: unmap all
typeset -a gotoModeBinds=(g k l h i j e t b c a f .)
print -rl -- 'try %• map global goto %·'${^gotoModeBinds}'· "" •'

# insert mode: unmap just c-n and c-p
typeset -a insertModeCtrl=(n p)
print -rl -- 'try %• map global insert %·<c-'${^insertModeCtrl}'>· "" •'

# man mode: unmap j k
typeset -a manModeBinds=(j k)
print -rl -- 'try %• map global man %·'${^manModeBinds}'· "" •'

# normal mode:
#   unmap h/j/k/l
#   also q ⇔ b and f ⇔ e, p ⇔ z ⇔ h
#   a-; ⇔ a-:
typeset -a normalModeBinds=(h j k l f e q b p z ';')
typeset -a normalModeMods=(a- s- a-s-)
print -rl -- 'try %• map global normal %·'${^normalModeBinds}'· "" •'
print -rl -- 'try %• map global normal %·<'${^normalModeMods}${^normalModeBinds}'>· "" •'

# normal mode: unmap c-[bfdjkios]
typeset -a normalModeCtrlBinds=(b f u d j k i o s)
print -rl -- 'try %• map global normal %·<c-'${^normalModeCtrlBinds}'>· "" •'

# prompt mode: unmap all alt and control keys
typeset -a promptModeBinds=(n p y u k d w e b f h a)
typeset -a promptModeMods=(a- a-s- c- c-s-)
print -rl -- 'try %• map global prompt %·<'${^promptModeMods}${^promptModeBinds}'>· "" •'

# view mode: unmap hjkl
typeset -a viewModeBinds=(h j k l)
print -rl -- 'try %• map global view %·'${^viewModeBinds}'· "" •'

