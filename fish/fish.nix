{ config, ... }:

{
  imports = [
    ./keybindings.nix
  ];

  xdg.configFile."fish/functions.fish".source = ./functions.fish;

  programs.fish = {
    enable = true;
    interactiveShellInit = # fish
      ''
      source ${config.xdg.configHome}/fish/functions.fish
      '';
  };
}
