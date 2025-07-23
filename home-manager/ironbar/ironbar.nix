{ inputs, system, config, pkgs, lib, ... }:

# to debug mpris:
# set IRONBAR_FILE_LOG and IRONBAR_LOG=info,ironbar::clients::mpris=trace

let

  # seems to be broken for now
  # menu = {
  #   type = "menu";
  # };

  bindmode-with-hints = {
    type = "custom";
    name = "bindmode-hints";

    bar = [
      {
        type = "button";
        on_click = "popup:toggle";
        widgets = [
          { type = "bindmode"; }
        ];
      }
    ];

    popup = [
      {
        type = "label";
        label = "#bindmode-hints";
      }
    ];
  };

  hyprscrollerMode = {
    type = "label";
    label = "#hyprscrollerMode";
    class = "hyprscroller-mode";
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
    truncate = {
      mode = "middle";
      max_length = 60;
    };
  };

  tray = {
    type = "tray";
  };

  music = {
    type = "music";
    # TODO: implement https://github.com/JakeStanger/ironbar/issues/1011
    truncate = {
      mode = "start";
      max_length = 60;
      length = 60;
    };
    truncate_popup_title = {
      mode = "middle";
      max_length = 90;
    };
  };

  keyboardLayouts = {
    type = "keyboard";
    show_caps = false;
    show_num = false;
    show_scroll = false;
    icons.layout_map = {
      "Carpalx*"  = "🇺🇸";
      "Estonian*" = "🇪🇪";
      "Russian*"  = "🇷🇺";
    };
  };

  workspaces = {
    type = "workspaces";
    # TODO: open a PR adding globbing?
    hidden = [ "special:magic" "special:special" "special:aichat" "special:btm" ];
  };

  hyprbarConf = {
    name = "hyprbar";
    position = "top";
    height = 24;
    start = [ workspaces hyprscrollerMode bindmode-with-hints ];
    center = [ music ];
    end = [ tray keyboardLayouts volume clock ];
    ironvar_defaults = {
      hyprscrollerMode = "⇒";
    };
  };

  stylesheet = 
    pkgs.runCommandLocal "ironbar-styles" {}
      ''
      ${lib.getExe' pkgs.nodePackages.sass "sass"} ${./style.scss} $out
      '';

in

{

  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    package = inputs.ironbar.packages.${system}.ironbar;
    style = stylesheet;
    config = hyprbarConf;
    systemd = true;
  };

}

