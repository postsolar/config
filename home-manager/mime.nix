{ pkgs, ... }:

let
  browsers = "brave-browser.desktop";
  terminals = "kitty.desktop";
  file-managers = [ "yazi.desktop" "nemo.desktop" ];
  image-viewers = "org.gnome.eog.desktop";
  text-editors = "Helix.desktop";

  associations = {
    # terminal
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
    "text/*"                    = text-editors;
    "application/x-*script"     = text-editors;
    "application/yaml"          = text-editors;
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
      selector = "walker -d -k -p 'Open with:'"
      term_exec_args = '-e'
      expand_wildcards = true
      '';
  };

}

