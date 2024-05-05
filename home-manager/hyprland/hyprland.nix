{ inputs, system, lib, config, pkgs, ... }:

let

  hlPkgSettings = _: { enableXWayland = false; };

  hyprland =
    inputs.hyprland.packages.${system}.hyprland.override hlPkgSettings
    ;

  hy3_updateToHL39_0 = pkgs.fetchpatch {
    url = "https://github.com/github-usr-name/hy3/compare/feature/focus-by-keyboard...outfoxxed%3Ahy3%3Amaster.patch";
    hash = "sha256-JtgdilIZLLGFlw9ROCD6uoUd7KBa9HWDBmzrouP06p0=";
  };
  hy3 = inputs.hy3.packages.${system}.hy3.overrideAttrs (o: {
    patches = o.patches or [] ++ [ hy3_updateToHL39_0 ];
  });

  # makeHyprlangVars : AttrSet String → Lines
  makeHyprlangVars = r:
    builtins.concatStringsSep "\n"
      (lib.attrsets.mapAttrsToList (k: v: "\$${k} = ${v}") r)
    ;

in

{

  imports = [
    ./hypridle.nix
    ./looks/default.nix
    ./looks/ink.nix
  ];

  xdg.configFile = {

    # hyprland-specific scripts
    "hypr/scripts/gaps.zsh".source                       = ./gaps.zsh;
    "hypr/scripts/move-floating-or-tiled-win.zsh".source = ./move-floating-or-tiled-win.zsh;

    # desktop theme attributes exported as hyprlang variables
    "hypr/colors.conf".text =
      makeHyprlangVars
        ({ inherit (config.theme) monospaceFont; } // config.theme.colorsNoPrefix)
      ;

    "hypr/window-rules.conf".source    = ./window-rules.conf;

    "hypr/keybindings.conf".source     = ./keybindings.conf;

    # plugins
    "hypr/hy3.conf".source             = ./hy3.conf;
    "hypr/hy3_keybindings.conf".source = ./hy3_keybindings.conf;
    "hypr/hyprexpo.conf".source        = ./hyprexpo.conf;
    "hypr/hyprtrails.conf".source      = ./hyprtrails.conf;
    "hypr/hyprspace.conf".source       = ./hyprspace.conf;

  };

  wayland.windowManager.hyprland = {

    enable = true;
    systemd.enable = true;

    package = hyprland;

    plugins = [
      hy3
      inputs.hyprland-plugins.packages.${system}.hyprexpo
      inputs.hyprland-plugins.packages.${system}.hyprtrails
      inputs.Hyprspace.packages.${system}.Hyprspace
    ];

    extraConfig =
      /* hyprlang */
      ''
      env = GDK_BACKEND, wayland
      env = QT_QPA_PLATFORM, wayland
      # makes firefox crash
      # env = GBM_BACKEND, nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME, nvidia
      env = LIBVA_DRIVER_NAME, nvidia
      env = VDPAU_DRIVER, nvidia
      env = MOZ_DISABLE_RDD_SANDBOX, 1
      env = MOZ_ENABLE_WAYLAND, 1
      env = MOZ_DRM_DEVICE, /dev/dri/renderD129
      env = WLR_NO_HARDWARE_CURSORS, 1
      env = WLR_backend, vulkan
      env = DRI_PRIME, pci-0000_03_00_0
      env = NVD_BACKEND, direct
      env = NVD_BACKEND__GLX_VENDOR_LIBRARY_NAME, nvidia

      # put everything onto nvidia card
      env = __NV_PRIME_RENDER_OFFLOAD, 1
      env = __NV_PRIME_RENDER_OFFLOAD_PROVIDER, NVIDIA-G0
      env = __GLX_VENDOR_LIBRARY_NAME, nvidia
      env = __VK_LAYER_NV_optimus, NVIDIA_only

      env = GTK_THEME, ${config.gtk.theme.name}
      env = XCURSOR_THEME, ${config.gtk.cursorTheme.name}
      env = XCURSOR_SIZE, ${toString config.gtk.cursorTheme.size}

      $scripts = ${config.xdg.configHome}/hypr/scripts
      # main configuration
      source = ${config.xdg.configHome}/hypr/colors.conf
      source = ${config.xdg.configHome}/hypr/window-rules.conf
      source = ${config.xdg.configHome}/hypr/keybindings.conf
      # plugins
      source = ${config.xdg.configHome}/hypr/hy3.conf
      source = ${config.xdg.configHome}/hypr/hy3_keybindings.conf
      source = ${config.xdg.configHome}/hypr/hyprexpo.conf
      source = ${config.xdg.configHome}/hypr/hyprtrails.conf
      source = ${config.xdg.configHome}/hypr/hyprspace.conf
      # looks
      source = ${config.xdg.configHome}/hypr/looks/default.conf
      source = ${config.xdg.configHome}/hypr/looks/ink.conf

      exec-once = hypridle
      exec-once = foot --server
      exec-once = swww-daemon
      exec-once = swww restore
      exec-once = ${pkgs.fusuma}/bin/fusuma
      exec-once = KANATA_PORT=4422 kanata-hyprland-layout-switcher-daemon
      # this systemd unit is broken so we just start it here
      exec-once = systemctl --user stop pueued.service; pueue -d

      monitor = DP-1, 1600x900@60, auto, auto
      monitor = eDP-1, disable

      general {
        layout                  = hy3
        cursor_inactive_timeout = 1
        no_cursor_warps         = yes
        no_focus_fallback       = yes
        resize_on_border        = yes
        extend_border_grab_area = 20
        hover_icon_on_border    = no
      }

      input {
        kb_layout          = us,ru
        kb_options         = compose:rctrl
        numlock_by_default = yes
        follow_mouse       = 2
        sensitivity        = 0.25

        touchpad {
          natural_scroll       = yes
          disable_while_typing = yes
          scroll_factor        = 1.25
        }
      }

      binds {
        workspace_back_and_forth = yes
      }

      animations {
        enabled = yes
      }

      misc {
        animate_manual_resizes           = yes
        animate_mouse_windowdragging     = yes
        disable_hyprland_logo            = yes
        focus_on_activate                = yes
        new_window_takes_over_fullscreen = 2
      }

      opengl {
        force_introspection = 0
      }

      '';

  };
}
