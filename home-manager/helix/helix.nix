{ pkgs, ... }:

# actual package is installed imperavitely to avoid extra rebuilds,
# especially for grammars, and to allow easier management

let
  languages   = builtins.readFile ./languages.toml;
  config      = builtins.readFile ./config.toml;
  keybindings = pkgs.callPackage ./keybindings.nix {};
in {

  imports = [
    ./themes.nix
    ./snippets.nix
  ];

  xdg.configFile."helix/languages.toml".text = languages;
  xdg.configFile."helix/config.toml".text = config + "\n" + builtins.readFile keybindings;

  home.packages = [
    (pkgs.makeDesktopItem {
      name = "helix";
      desktopName = "Helix";
      genericName = "Text editor";
      tryExec = "hx";
      exec = "hx -- %f";
      terminal = true;
      icon = "helix";
      mimeTypes = [ "text/*" "application/x-shellscript" "application/yaml" ];
    })
  ];

}
