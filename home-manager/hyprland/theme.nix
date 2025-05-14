{ config, lib, pkgs, ... }:

let
  unhash = lib.strings.removePrefix "#";
  colors = lib.mapAttrs (lib.const unhash) config.theme.colors;

  dynamic-colors = pkgs.writers.writeTSBin
    "hyprland-dynamic-color-changer"
    {}
    (builtins.readFile ./scripts/dynamic-color-changer.ts)
    ;
in

{

  home.packages = [
    dynamic-colors
  ];

  xdg.configFile."hypr/theme.hl".text = /* hyprlang */
    ''
    $active = ff69b4 # hotpink
    $inactive = ffc0cb # pink
    $locked = ${colors.terminalBright5}

    general {
      border_size = 4
      col.active_border = 0xff$active
      col.inactive_border = 0xff$inactive
      gaps_in = 10
      gaps_out = 10
    }

    misc {
      disable_hyprland_logo = yes
    }

    decoration {
      rounding = 4
      rounding_power = 10.0

      shadow {
        enabled = yes
        range = 6
        offset = 4 4
        color = 0x66000000
        render_power = 1
      }

      blur {
        size = 3
        passes = 3
        noise = 0
      }
    }

    group {
      col.border_active          = 0xff$active
      col.border_inactive        = 0x66$inactive
      col.border_locked_active   = 0xcc$locked
      col.border_locked_inactive = 0x88$locked

      groupbar {
        gradients = yes
        # title bar
        render_titles = no
        font_family = sans-serif
        font_size = 11
        height = 0
        # indicator bar
        indicator_height = 4

        scrolling = no
        rounding = 0
        gradient_rounding = 0

        col.active          = 0xff$active
        col.inactive        = 0x66$inactive
        col.locked_active   = 0xcc$locked 
        col.locked_inactive = 0x44$locked 

        gaps_in = 4
        gaps_out = 2
      }
    }

    animation = workspaces, 1, 10, default, slidevert

    animation = windowsIn, 1, 14, default, gnomed
    animation = windowsOut, 1, 14, default, gnomed
    animation = windowsMove, 1, 10, default, slide

    animation = layers, 1, 14, default, slide
    '';

}

