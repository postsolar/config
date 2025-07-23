{ inputs, config, pkgs, flakeDir, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hlPackage = inputs.hyprland.packages.${system}.hyprland;
  hlPortalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  hyprscroller = inputs.hyprscroller.packages.${system}.hyprscroller;

  link = f: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home-manager/hyprland/${f}";
in

{
  imports = [
    ./services.nix
  ];

  xdg.configFile = {
    "hypr/main.hl".source           = link "main.hl";
    "hypr/rules.hl".source          = link "rules.hl";
    "hypr/binds/core.hl".source     = link "binds/core.hl";
    "hypr/theme.hl".source          = link "theme.hl";
    "hypr/scripts".source           = link "scripts";

    "hypr/dwindle.hl".source        = link "dwindle.hl";
    "hypr/binds/dwindle.hl".source  = link "binds/dwindle.hl";

    "hypr/scroller.hl".source       = link "scroller.hl";
    "hypr/binds/scroller.hl".source = link "binds/scroller.hl";
  };

  wayland.windowManager.hyprland = {
    enable = true;

    systemd.enable = true;
    systemd.enableXdgAutostart = true;
    systemd.variables = [ "--all" ];

    package = hlPackage;
    portalPackage = hlPortalPackage;

    plugins = [
      hyprscroller
    ];

    extraConfig = /* hyprlang */
      ''
      # config variables

      $scripts = ${config.xdg.configHome}/hypr/scripts
      $conf = ${config.xdg.configHome}/hypr

      # entrypoint

      source = $conf/main.hl
      '';
  };
}
