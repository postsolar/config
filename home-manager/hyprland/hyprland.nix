{ inputs, config, lib, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hlPackage = inputs.hyprland.packages.${system}.hyprland;
  hlPortalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
in

{
  imports = [
    ./hypridle.nix
    ./theme.nix
  ];

  systemd.user.services.hyprland-per-window-layout = {
    Unit = {
      Description = "Hyprland per-window layouts daemon";
      Requires = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
    Service = {
      ExecStart = "${lib.getExe pkgs.hyprland-per-window-layout}";
    };
  };

  systemd.user.services.hyprland-helpers = {
    Unit = {
      Description = "My Hyprland helpers";
      Requires = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.bun} ${./HyprHelpers/HyprHelpers.ts}";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = [ "PATH=${lib.makeBinPath [ pkgs.socat hlPackage ]}" ];
    };
  };

  xdg.configFile = {
    # hyprland
    "hypr/binds.hl".source     = ./binds.hl;
    "hypr/rules.hl".source     = ./rules.hl;
    # plugins
    "hypr/hyprspace.hl".source = ./hyprspace.hl;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.enableXdgAutostart = true;

    package = hlPackage;
    portalPackage = hlPortalPackage;

    plugins = [
      # FIXME: fails to build as of 17/04/2025
      # inputs.hyprspace.packages.${system}.Hyprspace
    ];

    extraConfig = /* hyprlang */
      ''
      # set the scripts directory
      $scripts = ${./scripts}

      # window/layer/workspace rules

      source = ${config.xdg.configHome}/hypr/rules.hl

      # keybindings

      source = ${config.xdg.configHome}/hypr/binds.hl

      # looks

      source = ${config.xdg.configHome}/hypr/theme.hl

      # plugins

      source = ${config.xdg.configHome}/hypr/hyprspace.hl

      # autostart

      # copy doesn't work when started as a systemd service
      exec-once = flameshot

      # settings

      monitor = eDP-1, disable

      general {
        layout = dwindle
        resize_on_border = yes
        extend_border_grab_area = 30
      }

      dwindle {
        preserve_split = yes
      }

      input {
        kb_layout = us,ee,ru
        kb_variant = colemak_dh_iso,,
        kb_options = compose:rctrl,grp:win_space_toggle
        numlock_by_default = yes
        # same binds on all layouts
        resolve_binds_by_sym = no
        follow_mouse = 2
        sensitivity = 0.25
        touchpad {
          natural_scroll = yes
          disable_while_typing = yes
          scroll_factor = 1.25
        }
      }

      misc {
        disable_splash_rendering = yes
        mouse_move_enables_dpms = yes
        key_press_enables_dpms = yes
        animate_manual_resizes = yes
        animate_mouse_windowdragging = yes
        new_window_takes_over_fullscreen = 1
        focus_on_activate = true
        anr_missed_pings = 3
      }

      binds {
        workspace_back_and_forth = yes
        allow_workspace_cycles = yes
        movefocus_cycles_fullscreen = yes
      }

      cursor {
        inactive_timeout = 3
        no_warps = yes
      }

    '';
  };
}
