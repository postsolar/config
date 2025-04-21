{ config, lib, pkgs, ... }:

{
  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };
}

