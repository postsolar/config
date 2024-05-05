#! /usr/bin/env zsh

# copy and optionally save (with flag --save) a screenshot

# default location and filename
f=${SCREENSHOTS_DIR-$HOME}/${ date '+Screenshot @ %c' }
tmp=${ mktemp }

{(
  set -e
  flameshot gui -r > $tmp 2> /dev/null
  [[ -s $tmp ]]
  wl-copy < $tmp
  if [[ ${1-} = --save ]]; then
    ff=${ yad --file --save --filename=$f }
    mv -- $tmp $ff
  fi
)} always {
  command rm -f -- $tmp
  return 0
}

