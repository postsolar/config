{ inputs, config, pkgs, lib, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hlPackage = inputs.hyprland.packages.${system}.hyprland;
  hlPortalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

  hyprscroller = inputs.hyprscroller.packages.${system}.hyprscroller;

in

{
  imports = [
    ./services.nix
    ./theme.nix
  ];

  xdg.configFile = {
    "hypr/rules.hl".source          = ./rules.hl;
    "hypr/binds/core.hl".source     = ./binds/core.hl;
    "hypr/scripts".source           = ./scripts;

    "hypr/dwindle.hl".source        = ./dwindle.hl;
    "hypr/binds/dwindle.hl".source  = ./binds/dwindle.hl;

    "hypr/scroller.hl".source       = ./scroller.hl;
    "hypr/binds/scroller.hl".source = ./binds/scroller.hl;
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

      # environment

      env = NIXOS_OZONE_WL, 1

      # autostart

      # window/layer/workspace rules

      source = $conf/rules.hl

      # looks

      source = $conf/theme.hl

      # plugins and layout conf

      # source = $conf/dwindle.hl
      source = $conf/scroller.hl

      # core, layout-independent conf

      monitor = eDP-1, disable
      monitor = DP-1, 1600x900, auto, auto

      general {
        snap {
          enabled = yes
          window_gap = 30
          monitor_gap = 30
          border_overlap = yes
        }
      }

      input {
        kb_layout = carpalx-qwyrfm,ru
        kb_variant = ,ruu
        kb_options = compose:rctrl,grp:win_space_toggle,caps:escape
        # kb_rules
        # kb_file
        numlock_by_default = yes

        sensitivity = 0.25
        accel_profile = adaptive

        touchpad {
          natural_scroll = yes
          disable_while_typing = yes
          scroll_factor = 1.25
          drag_lock = 0
        }
      }

      misc {
        disable_splash_rendering = yes
        mouse_move_enables_dpms = yes
        key_press_enables_dpms = yes
        animate_manual_resizes = yes
        animate_mouse_windowdragging = yes
        new_window_takes_over_fullscreen = 1
        focus_on_activate = yes
        enable_anr_dialog = no
      }

      binds {
        workspace_back_and_forth = yes
        allow_workspace_cycles = yes
        movefocus_cycles_fullscreen = yes
      }

      cursor {
        inactive_timeout = 3
        persistent_warps = yes
      }
    '';
  };
}
