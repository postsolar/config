alias reload="exec zsh"

alias sudo="sudo -E"

# nix aliases

export NIXPKGS_ALLOW_UNFREE=1

alias nix-gc="command sudo nix-collect-garbage -d"
alias nix-delete="command sudo nix store delete"
ns () nix shell 'nixpkgs#'${^@} --impure

# files
alias e="eza --icons always --color always --reverse --hyperlink --no-quotes --git --all"
alias e1="e --oneline"
alias ee="e --long"
alias et="e --tree"

alias md="mkdir -p"
mcd () { mkdir -p -- $1 && cd $1 }

rm () {
  if [[ $1 = "-rf" ]]; then
    print 'use `purge` instead'
    return 1
  fi
  local ts="$(date --iso-8601=seconds)"
  local dir=$XDG_DATA_HOME/trash/$ts
  mkdir -p -- $dir
  mv -- $@ $dir
}
alias purge="command rm -rf"

alias lf="lf -log ${TMP_DIR:-/tmp}/lf.log -command 'echo welcome back to lf!'"
lfcd () { cd "$(lf -command 'echo welcome back to lf!' -print-last-dir $@)" }

alias mx="chmod +x"

# downloads
alias curl="curl -L"
alias dl="curl -LO"

# misc
alias ka="killall"

alias ff="fastfetch"
alias hf="hyperfine"
alias hc="hyprctl"
alias bb="btm"

