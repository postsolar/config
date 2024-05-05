{ ... }:

{

  xdg.configFile."hypr/looks/default.conf".text =
    # hyprlang
    ''
    general {
      border_size         = 3
      gaps_in             = 8
      gaps_out            = 20
      col.active_border   = 0xff$color5 0x44$color15 45deg
      col.inactive_border = 0x44$color15 0x44$color15 0deg
    }


    decoration {
      rounding           = 5
      active_opacity     = 0.90
      inactive_opacity   = 0.80
      fullscreen_opacity = 0.90

      drop_shadow          = yes
      shadow_range         = 8
      shadow_render_power  = 1
      shadow_ignore_window = yes
      col.shadow           = 0x66$color5
      col.shadow_inactive  = 0x30$color15
      shadow_offset        = 5 5
      shadow_scale         = 0.99

      dim_inactive         = no
      dim_strength         = 0.2
      dim_special          = 0.5
      dim_around           = 0.8

      blur {
        enabled           = yes
        size              = 1
        passes            = 3
        ignore_opacity    = yes
        xray              = yes
        noise             = 0.00
        contrast          = 1.00
        brightness        = 2.00
        vibrancy          = 0.20
        vibrancy_darkness = 0.80
        special           = no
      }

    }

    animations {

      bezier = linear, 1, 1, 1, 1
      bezier = easeInBack, 0.36, 0, 0.66, -0.56
      bezier = easeInCirc, 0.55, 0, 1, 0.45
      bezier = easeInCubic, 0.32, 0, 0.67, 0
      bezier = easeInExpo, 0.7, 0, 0.84, 0
      bezier = easeInOutBack, 0.68, -0.6, 0.32, 1.6
      bezier = easeInOutCirc, 0.85, 0, 0.15, 1
      bezier = easeInOutCubic, 0.65, 0, 0.35, 1
      bezier = easeInOutExpo, 0.87, 0, 0.13, 1
      bezier = easeInOutQuad, 0.45, 0, 0.55, 1
      bezier = easeInOutQuart, 0.76, 0, 0.24, 1
      bezier = easeInOutQuint, 0.83, 0, 0.17, 1
      bezier = easeInOutSine, 0.37, 0, 0.63, 1
      bezier = easeInQuad, 0.11, 0, 0.5, 0
      bezier = easeInQuart, 0.5, 0, 0.75, 0
      bezier = easeInQuint, 0.64, 0, 0.78, 0
      bezier = easeInSine, 0.12, 0, 0.39, 0
      bezier = easeOutBack, 0.34, 1.56, 0.64, 1
      bezier = easeOutCirc, 0, 0.55, 0.45, 1
      bezier = easeOutCubic, 0.33, 1, 0.68, 1
      bezier = easeOutExpo, 0.16, 1, 0.3, 1
      bezier = easeOutQuad, 0.5, 1, 0.89, 1
      bezier = easeOutQuart, 0.25, 1, 0.5, 1
      bezier = easeOutQuint, 0.22, 1, 0.36, 1
      bezier = easeOutSine, 0.61, 1, 0.88, 1

      animation = workspaces, 1, 8, easeInOutExpo, fade
      animation = borderangle, 1, 80, easeInBack, loop
      animation = border, 1, 20, easeOutSine

      animation = windowsMove, 1, 5, easeOutQuart, popin

      animation = windowsIn, 1, 10, easeOutCirc, popin
      animation = fadeIn, 1, 10, easeOutCirc

      animation = windowsOut, 1, 10, easeInOutQuint, popin
      animation = fadeOut, 1, 10, easeInOutQuint

    }


    plugin {
      hy3 {
        tabs {
          height = 5
          padding = 2
          from_top = true
          rounding = 1
          render_text = no
          col.active = 0xff$color5
          col.inactive = 0x55$color5
          # col.urgent =
        }
      }
    }
    ''
    ;

}
