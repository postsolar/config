{ inputs, system, config, pkgs, lib, ... }:

let

  # ~ clock
  # https://docs.rs/chrono/latest/chrono/format/strftime/index.html

  # 01:03:39
  timeFmtShort = "%R";
  # N 27 veebr 2025 01:03:39
  timeFmtLong = "%a %e %b %Y %X %Z";

  clock = {
    type = "clock";
    format = timeFmtShort;
  };

  # ~ volume
  volume = {
    type = "volume";
    format = "{icon} {percentage}%";
    max_volume = 150;
    icons = {
      volume_high = "󰕾";
      volume_medium = "󰖀";
      volume_low = "󰕿";
      muted = "󰝟";
    };
  };

  # ~ tray
  tray = {
    type = "tray";
  };

  # ~ music
  music = {
    type = "music";
    truncate = {
      mode = "start";
      max_length = 60;
    };
  };

  # ~ keyboard layouts
  keyboardLayouts = {
    type = "keyboard";
    show_caps = false;
    show_num = false;
    show_scroll = false;
    icons.layout_map = {
      "English*"  = "🇺🇸";
      "Estonian*" = "🇪🇪";
      "Russian*"  = "🇷🇺";
    };
  };

  # ~ niri keyboard layouts
  keyboardLayoutsNiri = {
    type = "script";
    cmd = "${lib.getExe pkgs.bun} ${./niri-layout-stream.ts}";
    mode = "watch";
    on_click_left = "niri msg action switch-layout next";
    class = "keyboard niri-keyboard";
  };

  # ~ focused
  focused = {
    type = "focused";
    icon_size = 16;
    truncate = {
      mode = "end";
      length = 60;
      max_length = 60;
    };
  };

  # ~ workspaces
  workspaces = {
    type = "workspaces";
    hidden = [ "special:magic" ];
  };

  hyprbarConf = {
    name = "hyprbar";
    position = "top";
    height = 30;
    start = [ workspaces ];
    center = [ clock ];
    end = [ music tray keyboardLayouts volume ];
  };

  niribarConf = {
    name = "niribar";
    position = "top";
    height = 30;
    start = [ workspaces ];
    center = [ clock ];
    end = [ tray keyboardLayoutsNiri music volume ];
  };

  stylesheet = 
    let
      style = pkgs.writeText "ironbar-theme.scss" <| import ./style.nix config.theme;
    in
      pkgs.runCommandLocal "ironbar-styles" {}
        ''
        ${lib.getExe' pkgs.nodePackages.sass "sass"} ${style} $out
        '';

  mkIronbarSystemdService = name: conf: targets:
    {
      Unit = {
        Description = "Systemd service for Ironbar";
        Requires = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe config.programs.ironbar.package}";
        Environment = [ "IRONBAR_CONFIG=${ (pkgs.formats.json {}).generate "ironbar-${name}.json" conf }" ];
        Restart = "on-failure";
      };
      Install.WantedBy = targets;
    };

in

{

  imports = [ inputs.ironbar.homeManagerModules.default ];

  programs.ironbar = {
    enable = true;
    systemd = false;
    package = inputs.ironbar.packages.${system}.ironbar;
    style = stylesheet;
  };

  systemd.user.services = {
    ironbar-hyprland = mkIronbarSystemdService "hypr" hyprbarConf [ "hyprland-session.target" ];
    ironbar-niri = mkIronbarSystemdService "niri" niribarConf [ "niri.service" ];
  };

}

