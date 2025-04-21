{ pkgs, inputs, ... }:

{

  imports = [
    inputs.niri-flake.homeModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    config = null;
    settings = null;
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

}

