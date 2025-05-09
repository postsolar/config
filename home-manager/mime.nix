{ pkgs, ... }:

let
  browsers = [ "firefox.desktop" ];
  terminals = [ "kitty.desktop" "foot.desktop" ];
  file-managers = [ "lf.desktop" "nemo.desktop" ];
  image-viewers = [ "swayimg.desktop" ];
  text-editors = "Helix.desktop";

  associations = {
    # term
    "x-scheme-handler/terminal" = terminals;

    # web
    "x-scheme-handler/https"    = browsers;
    "x-scheme-handler/http"     = browsers;
    "x-scheme-handler/about"    = browsers;
    "x-scheme-handler/unknown"  = browsers;
    "text/html"                 = browsers;

    # files
    "inode/directory"           = file-managers;

    # pictures
    "image/*"                   = image-viewers;

    # text
    "application/x-*script"     = text-editors;
    "text/*"                    = text-editors;
  };

in

{
  home.packages = [
    pkgs.handlr-regex
    (pkgs.writeShellScriptBin "xdg-open" ''handlr open "$@"'')
    (pkgs.writeShellScriptBin "xterm" "handlr launch x-scheme-handler/terminal -- \"$@\"")
  ];

  xdg.mimeApps = {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };

  xdg.configFile = {
    "handlr/handlr.toml".text =
      ''
      enable_selector = true
      selector = "sherlock"
      term_exec_args = '-e'
      expand_wildcards = true
      '';
  };

}

