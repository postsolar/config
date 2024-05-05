{ pkgs, config, ... }:

let
  clipboard-picker = pkgs.writeScriptBin "clipboard-picker" /* zsh */
    ''
    #! ${config.programs.zsh.package}/bin/zsh
    if [[ ''${1-} = preview ]]; then
      row=$2
      if print -r -- $row | rg -q '^\d+\t\[\[ binary data .*? \]\]$'; then
        print -r -- $row | cliphist decode | chafa -f sixel -s $FZF_PREVIEW_COLUMNS'x'$FZF_PREVIEW_LINES
      else
        print -r -- $row | cliphist decode
      fi
    else
      id=''${ cliphist list | fzf --preview "''${(%):-%x} preview {}" }
      [[ $id ]] || exit
      cliphist decode <<< $id | wl-copy
    fi
    ''
    ;
in

{
  services.cliphist.enable = true;
  home.packages = [ clipboard-picker ];
}

