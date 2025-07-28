{ pkgs, config, ... }:

# TODO try gradia

let
  screenshot = pkgs.writers.writeDashBin "screenshot"
    ''
    grim -t ppm - | satty --filename - "$@"
    '';
in

{
  home.packages = [
    pkgs.satty
    pkgs.grim
    pkgs.slurp
    screenshot
  ];

  xdg.configFile."satty/config.toml".text = # toml
    ''
    [general]
    fullscreen = true
    early-exit = false
    corner-roundness = 0
    initial-tool = "crop"
    copy-command = "wl-copy -t image/png"
    annotation-size-factor = 1
    output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/Screenshot %d.%m.%Y %H:%M:%S.png"
    save-after-copy = false
    default-hide-toolbars = false
    primary-highlighter = "freehand"
    disable-notifications = false
    actions-on-right-click = []
    actions-on-enter = ["save-to-clipboard", "exit"]
    actions-on-escape = ["exit"]

    [font]
    # family = "sans"
    # style = "Regular"
    '';
}

