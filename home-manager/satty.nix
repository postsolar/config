{ config, lib, pkgs, ... }:

let
  screenshot = pkgs.writers.writeDashBin "screenshot"
    ''
    grim -t ppm - | satty --filename -
    '';
in

{
  home.packages = [
    pkgs.satty
    pkgs.grim
    pkgs.slurp
    screenshot
  ];

  xdg.configFile."satty/config.toml".text =
    ''
    [general]
    fullscreen = true
    output-filename = "~/Pictures/Screenshots/Screenshot %d.%m.%Y %H:%M:%S.png"
    copy-command = 'wl-copy -t image/png'
    '';
}

