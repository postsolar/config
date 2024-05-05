#! /usr/bin/zsh

# helper function to get the word under the cursor

word-under-cursor () {
  # shell words, all and those to the left of the cursor
  local -a  words=( ${(z)BUFFER} )
  local -a lwords=( ${(z)LBUFFER} )

  # number of words to the left of the cursor
  local -i lcurrent=$#lwords
  local -i rcurrent=$#lwords

  # portions of the word to the left and right of cursor
  local prefix=${lwords[lcurrent]-}
  local suffix=${${words[rcurrent]-}#$prefix}
  local word="$prefix$suffix"

  print -- $word

}

