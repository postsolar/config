{ config, flakeDir, ... }:

{
  imports = [
    ./keybindings.nix
  ];

  xdg.configFile."fish/functions.fish".source = ./functions.fish;
  xdg.configFile."fish/conf.d/homebrew.fish".source = ./homebrew.fish;

  programs.fish = {
    enable = true;

    interactiveShellInit = # fish
      ''
      source ${config.xdg.configHome}/fish/functions.fish
      '';
  };
}
