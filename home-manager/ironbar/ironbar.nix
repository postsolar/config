{ inputs, system, config, pkgs, lib, ... }:

# to debug mpris:
# set IRONBAR_FILE_LOG and IRONBAR_LOG=info,ironbar::clients::mpris=trace

let

  wlinhibit = {
    type = "label";
    label =
      let
        script = # sh
          ''
          label=
          active='<span color="white">'$label'</span>'
          inactive='<span color="gray">'$label'</span>'

          while true; do
            sleep 0.5
            if pgrep wlinhibit; then
              ironbar var set wlinhibit "$active"
              pidwait wlinhibit
            else
              ironbar var set wlinhibit "$inactive"
            fi
          done >/dev/null 2>&1
          '';
      in
        ''{{watch:${script}}}#wlinhibit'';
    class = "wlinhibit";
    on_click_left = # sh
      ''
      # use a systemctl service for wlinhibit because otherwise it'd be killed by ironbar exiting
      # this could be addressed in other ways too, but this one is relatively clean and simple
      if pgrep wlinhibit; then
        systemctl --user stop wlinhibit.service
        notify-send -u low -i system 'sleep inhibition off'
      else
        systemctl --user start wlinhibit.service
        notify-send -u low -i system 'sleep inhibition on'
      fi
      '';
  };

  # seems to be broken for now
  # menu = {
  #   type = "menu";
  # };

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
    # TODO: implement https://github.com/JakeStanger/ironbar/issues/1011 )
    # truncate = {
    #   mode = "start";
    #   max_length = 60;
    # };
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
    height = 24;
    start = [ workspaces hyprscrollerMode bindmode ];
    center = [ music ];
    end = [ tray wlinhibit keyboardLayouts volume clock ];
    ironvar_defaults = {
      hyprscrollerMode = "⇒";
    };
  };

  niribarConf = {
    name = "niribar";
    position = "top";
    height = 30;
    start = [ workspaces ];
    center = [ music ];
    end = [ tray wlinhibit keyboardLayoutsNiri volume clock ];
  };

  stylesheet = 
    pkgs.runCommandLocal "ironbar-styles" {}
      ''
      ${lib.getExe' pkgs.nodePackages.sass "sass"} ${./style.scss} $out
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

  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  home.packages = [
    pkgs.wlinhibit
  ];

  programs.ironbar = {
    enable = true;
    systemd = false;
    package = inputs.ironbar.packages.${system}.ironbar;
    style = stylesheet;
  };

  systemd.user.services = {
    ironbar-hyprland = mkIronbarSystemdService "hypr" hyprbarConf [ "hyprland-session.target" ];
    ironbar-niri = mkIronbarSystemdService "niri" niribarConf [ "niri.service" ];

    wlinhibit = {
      Unit.Description = "Systemd service for wlinhibit";
      Service.Type = "simple";
      Service.ExecStart = "${lib.getExe' pkgs.wlinhibit "wlinhibit"}";
      Install = {};
    };
  };

}

