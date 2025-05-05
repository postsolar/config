{ inputs, pkgs, ... }:

{

  imports = [
    inputs.niri-flake.homeModules.niri
    ./config.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    # config = null;
    # settings = null;
  };

}

