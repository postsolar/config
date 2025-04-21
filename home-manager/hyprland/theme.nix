{ config, lib, ... }:

let
  unhash = lib.strings.removePrefix "#";
  colors = lib.mapAttrs (lib.const unhash) config.theme.colors;
in

{

  xdg.configFile."hypr/theme.hl".text = /* hyprlang */
    ''
    $active = ${colors.border}
    $inactive = 111111
    $locked = ${colors.terminalBright5}

    general {
      border_size = 3
      col.active_border = 0xff$active
      col.inactive_border = 0x66$inactive
      gaps_in = 4
      gaps_out = 4
    }

    misc {
      disable_hyprland_logo = yes
    }

    decoration {
      rounding = 0
      shadow {
        enabled = true
        offset = 5 5
        render_power = 1
        color = 0xaa999999
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

    plugin {
      overview {
        workspaceActiveBorder = 0xff${colors.border2}
        workspaceInactiveBorder = 0x88ffffff
        dragAlpha = 0.5
      }
    }
    '';

}

