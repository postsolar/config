#! /usr/bin/env zsh

url=${ fx -r decodeURIComponent <<< $1 }
name=${${1:gs/%/-/}:t}

nix hash convert \
  --hash-algo sha256 \
  --from nix32 \
  ${ nix-prefetch-url --name $name $url }

