{ inputs, config, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hlPackage = inputs.hyprland.packages.${system}.hyprland;
  hlPortalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

  hyprscroller = pkgs.hyprlandPlugins.hyprscroller.overrideAttrs (_: _: {
    src = inputs.hyprscroller;
    buildInputs = [ hlPackage ] ++ hlPackage.buildInputs;
  });
in

{
  imports = [
    ./services.nix
    ./theme.nix
  ];

  xdg.configFile = {
    "hypr/rules.hl".source         = ./rules.hl;
    "hypr/binds/core.hl".source    = ./binds/core.hl;
    "hypr/dwindle.hl".source       = ./dwindle.hl;
    "hypr/binds/dwindle.hl".source = ./binds/dwindle.hl;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.enableXdgAutostart = true;

    package = hlPackage;
    portalPackage = hlPortalPackage;

    plugins = [
      hyprscroller
    ];

    extraConfig = /* hyprlang */
      ''
      # config variables

      $scripts = ${./scripts}
      $conf = ${config.xdg.configHome}/hypr

      # autostart

      # window/layer/workspace rules

      source = $conf/rules.hl

      # looks

      source = $conf/theme.hl

      # plugins and layout conf

      source = $conf/dwindle.hl

      # core, layout-independent conf

      monitor = eDP-1, disable
      monitor = DP-1, 1600x900, auto, auto

      input {
        # ref: /nix/store/<hash>-xkeyboard-config-2.43/share/X11/xkb/{symbols,rules}/
        # ref: https://nixos.org/manual/nixos/stable/#custom-xkb-layouts
        kb_layout = us,ru
        kb_variant = colemak_dh_iso,ruu
        kb_options = compose:rctrl,grp:win_space_toggle
        # kb_rules
        # kb_file
        numlock_by_default = yes

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
      }

    '';
  };
}
