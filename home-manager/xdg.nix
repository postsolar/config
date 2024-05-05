{ pkgs, ... }:

{
  home.file.".local/bin/xdg-open".source = pkgs.writeScript "xdg-open"
    ''
    #! /bin/sh
    ${pkgs.handlr-regex}/bin/handlr open "$@"
    '';
}

