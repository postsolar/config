{ ... }:

{

  # TODO use named colors?

  xdg.configFile."hypr/looks/ink.conf".text =
    # hyprlang
    ''
    general {
      border_size         = 3
      col.active_border   = 0xff604e7a
      col.inactive_border = 0x44$color15 0x44$color15 0deg
    }

    decoration {
      rounding            = 0
      shadow_offset       = 8 8
      col.shadow          = 0x66000000
      col.shadow_inactive = 0x30$color15
    }

    plugin {
      hy3 {
        tabs {
          height = 4
          padding = 2
          rounding = 0
          col.active = 0xff292C31
          col.inactive = 0x66221E26
        }
      }
    }

    plugin {
      overview {
        workspaceActiveBorder = 0xff604e7a
        workspaceInactiveBorder = 0x88$color15
        dragAlpha = 0.5
      }
    }
    '';

}

