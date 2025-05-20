{ inputs, system, config, pkgs, lib, ... }:

let

  bindmode = {
    type = "bindmode";
    transition_type = "crossfade";
  };

  hyprscrollerMode = {
    class = "hyprscroller-mode";
    type = "label";
    label = "#hyprscrollerMode";
  };

  clock = {
    type = "clock";
    format = "%R";
  };

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

  tray = {
    type = "tray";
  };

  music = {
    type = "music";
    truncate = {
      mode = "start";
      max_length = 60;
    };
  };

  keyboardLayouts = {
    type = "keyboard";
    show_caps = false;
    show_num = false;
    show_scroll = false;
    icons.layout_map = {
      "English*"  = "🇺🇸 (Colemak)";
      "Carpalx*"  = "🇺🇸 (Carpalx)";
      "Estonian*" = "🇪🇪";
      "Russian*"  = "🇷🇺";
    };
  };

  keyboardLayoutsNiri = {
    type = "script";
    cmd = "${lib.getExe pkgs.bun} ${./niri-layout-stream.ts}";
    mode = "watch";
    on_click_left = "niri msg action switch-layout next";
    class = "keyboard niri-keyboard";
  };

  workspaces = {
    type = "workspaces";
    hidden = [ "special:magic" "special:special" ];
  };

  hyprbarConf = {
    name = "hyprbar";
    position = "top";
    height = 30;
    start = [ workspaces hyprscrollerMode bindmode ];
    center = [ clock ];
    end = [ music tray keyboardLayouts volume ];
    ironvar_defaults = {
      hyprscrollerMode = "⇒";
    };
  };

  niribarConf = {
    name = "niribar";
    position = "top";
    height = 30;
    start = [ workspaces ];
    center = [ clock ];
    end = [ music tray keyboardLayoutsNiri volume ];
  };

  stylesheet = 
    let
      style = ./style.scss;
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

