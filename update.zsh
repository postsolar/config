#! /usr/bin/env zsh

nix flake metadata --json 2>/dev/null \
  | fx .locks.nodes.root.inputs values list \
  | sd 'nixpkgs_\d+' nixpkgs \
  | huniq \
  | fzf --bind enter:become:'
            echo updating inputs: {+}
            nix flake update {+}
          ' \
        --preview 'nix flake metadata --json 2>/dev/null | jq -C .locks.nodes.[\"{}\"]' \
      || :

