{ config, pkgs, ... }:

{
  imports = [
    ./codex.nix
  ];

  home.packages = [
    pkgs.opencode
  ];

  programs.opencode = {
    enable = true;
  };
}
