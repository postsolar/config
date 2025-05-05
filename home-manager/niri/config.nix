{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".text = # kdl
    ''
    // ref: https://github.com/YaLTeR/niri/wiki/Configuration:-Overview

    // ~ input

    input {
      keyboard {
        xkb {
          // ref: xkeyboard-config(7)
          layout "us,ru"
          variant "colemak_dh_iso,ruu"
          options "compose:rctrl,grp:win_space_toggle"
          // file "~/.config/keymap.xkb"
        }
        track-layout "window"
        numlock
      }

      touchpad {
        tap
        accel-speed 0.25
        drag true
        // wish the timeout here was configurable
        // drag-lock
        dwt
        dwtp
        natural-scroll
        scroll-factor 2.0
      }

      mouse {
        natural-scroll
      }

      trackpoint {
        natural-scroll
      }

      workspace-auto-back-and-forth
      warp-mouse-to-focus
      focus-follows-mouse // max-scroll-amount="0%"
    }

    // ~ output

    output "eDP-1" {
      off
    }

    // ~ layout

    layout {
      gaps 24

      focus-ring {
        // off
        width 4
        active-gradient from="hotpink" to="palevioletred" angle=210 relative-to="workspace-view"
      }

      border {
        off
        width 4
        active-color "#ffc87f"
        inactive-color "#505050"
        active-gradient from="#ffbb66" to="#ffc880" angle=45 relative-to="workspace-view"
        inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
      }

      shadow {
        on
        // draw-behind-window true
        softness 20
        spread 2
        offset x=8 y=8
        color "#00000099"
      }

      tab-indicator {
        gap -10
        position "bottom"
        gaps-between-tabs 5
      }

      // struts {
      //   left 4
      //   right 4
      //   top 8
      //   bottom 4
      // }

      preset-column-widths {
        proportion 0.25
        proportion 0.33
        proportion 0.50
        proportion 0.66
        proportion 0.75
        proportion 1.00
      }

      preset-window-heights {
        proportion 0.25
        proportion 0.33
        proportion 0.50
        proportion 0.66
        proportion 0.75
        proportion 1.00
      }

    }

    // ~ other

    prefer-no-csd

    screenshot-path "/tmp/Screenshots/%Y.%m.%d %H:%M:%S.png"

    cursor {
      hide-when-typing
      hide-after-inactive-ms 3000
    }

    // TODO
    environment {
    }

    // ~ animations

    // TODO
    animations {
      slowdown 2.0
    }

    // ~ rules

    // terminal opacity
    window-rule {
      match app-id="kitty"
      opacity 0.95
    }

    // telegram opacity
    window-rule {
      match app-id=r#"^org\.telegram\.desktop$"#
      exclude title="^Media viewer$"

      opacity 0.95
      draw-border-with-background false
    }

    // Windows that have to open floating
    window-rule {
      // Firefox PiP
      match app-id="^firefox$" title="^Picture-in-Picture$"
      match app-id="^firefox$" title="^Pilt-pildis$"
      // Chrome PiP
      match title="^Pilt pildis$"
      // Smile emoji picker
      match app-id="^it.mijorus.smile$"
      // CopyQ
      match app-id="^com\\.github\\.hluk\\.copyq$"
      // Emulate window tags
      match app-id="\\+float"

      open-floating true
    }

    // block notifications from screencasts
    layer-rule {
      match namespace="notification"
      match namespace="swaync-control-center"
      block-out-from "screencast"
    }

    // swayimg
    window-rule {
      match app-id="swayimg"
      open-floating true
      focus-ring {
        off
      }
      border {
        off
      }
      shadow {
        off
      }
      max-height 600
      max-width 1200
    }

    // ~ binds

    // TODO
    // pgup+pgdn for workspace switching/moving?

    binds {

      // ~ essential

      Mod+Q { close-window; }
      Mod+Shift+E { quit; }

      // ~ programs

      Mod+Return { spawn "kitty" "-1"; }
      Mod+Shift+Return { spawn "kitty" "-1" "--class" "kitty +float"; }

      // Mod+R { spawn "albert" "toggle"; }
      // Mod+Shift+R { spawn "fuzzel"; }
      Mod+S { spawn "sherlock"; }
      Mod+N { spawn "swaync-client" "--toggle-panel"; }

      Mod+O { spawn "copyq" "toggle"; }
      Mod+Apostrophe { spawn "smile"; }

      Print { spawn "screenshot"; }
      // a bit ugly as the API is currently lacking, but works fine
      // see https://github.com/YaLTeR/niri/discussions/1376
      Alt+Print { spawn "zsh" "-c" "
          niri msg action screenshot-window --id $(niri msg --json pick-window | jq .id)
          sleep 0.1
          satty -f /tmp/Screenshots/*(om[1])
        "; }

      // ~ hardware controls

      Mod+Shift+F10 { power-off-monitors; }

      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      F1                   allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" "--limit" "1.5"; }
      F2                   allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" "--limit" "1.5"; }
      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" "--limit" "1.5"; }
      F3                   allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" "--limit" "1.5"; }
      XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      F4                   allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      XF86AudioPlay        allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioPause       allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioStop        allow-when-locked=true { spawn "playerctl" "stop"; }
      XF86AudioPrev        allow-when-locked=true { spawn "playerctl" "previous"; }
      XF86AudioNext        allow-when-locked=true { spawn "playerctl" "next"; }
      Mod+XF86AudioPrev    allow-when-locked=true { spawn "playerctl" "position" "10-"; }
      Mod+XF86AudioNext    allow-when-locked=true { spawn "playerctl" "position" "10+"; }

      // ~ window state

      // fullscreen is kinda broken in the sense it doesn't restore previous column setup 🫠
      // it really just expels the window, maximizes it geometrically and sets internal fullscreen state
      Mod+F { fullscreen-window; }
      Mod+Shift+F { toggle-windowed-fullscreen; }

      Mod+P { toggle-window-floating; }
      Mod+Shift+P { switch-focus-between-floating-and-tiling; }

      Mod+B { toggle-window-rule-opacity; }

      // ~ focus change

      // broken because doesn't update previous window when, say, a window was closed
      // e.g. open W1, open W2, open W3, close W3 → bind won't toggle between W2 and W1
      Mod+A { focus-window-previous; }

      Mod+Left { focus-column-left-or-last; }
      Mod+Right { focus-column-right-or-first; }

      Mod+Up { focus-window-up; }
      Mod+Down { focus-window-down; }

      Mod+Tab { focus-workspace-down; }
      Mod+Shift+Tab { focus-workspace-up; }

      // this one would only be useful with indexed workspace switching though
      Mod+Grave { focus-workspace-previous; }

      // ~ movement

      // for movement left/right/up/down:
      // shift: act on a window
      // alt: act on a column

      Mod+Shift+Left  { spawn "sh" "${./scripts/move-helpers.sh}" "left"; }
      Mod+Shift+Right { spawn "sh" "${./scripts/move-helpers.sh}" "right"; }
      Mod+Shift+Up    { spawn "sh" "${./scripts/move-helpers.sh}" "up"; }
      Mod+Shift+Down  { spawn "sh" "${./scripts/move-helpers.sh}" "down"; }

      Mod+Alt+Left    { spawn "sh" "${./scripts/move-helpers.sh}" "left"  "--column"; }
      Mod+Alt+Right   { spawn "sh" "${./scripts/move-helpers.sh}" "right" "--column"; }
      Mod+Alt+Up      { spawn "sh" "${./scripts/move-helpers.sh}" "up"    "--column"; }
      Mod+Alt+Down    { spawn "sh" "${./scripts/move-helpers.sh}" "down"  "--column"; }

      Mod+BracketLeft { consume-window-into-column; }
      Mod+BracketRight { expel-window-from-column; }

      Mod+Shift+BracketLeft { consume-or-expel-window-right; }
      Mod+Shift+BracketRight { consume-or-expel-window-left; }

      // column state (and window height)

      Mod+W { toggle-column-tabbed-display; }

      // i fail to understand what's the difference between center-column and center-window
      Mod+C { center-column; }

      // there doesn't seem to be any difference between window and column width
      // ideally we'd want:
      //   comma - shrink width (cycle backward)
      //   period - expand width (cycle forward)
      //   less (S+comma) - shrink height (cycle backward)
      //   gt (S+period) - expand height (cycle forward)
      // but it's not yet implemented i think. could be fixed by just using a submap though?
      // i don't remember if they're already implemented
      Mod+Comma { switch-preset-window-width; }
      Mod+Period { switch-preset-window-height; }
      Mod+Shift+Period { reset-window-height; }
      Mod+Slash { maximize-column; }
      Mod+Alt+Slash { expand-column-to-available-width; }

      Mod+Minus { set-window-width "-5%"; }
      Mod+Equal { set-window-width "+5%"; }
      Mod+Alt+Minus { set-window-height "-5%"; }
      Mod+Alt+Equal { set-window-height "+5%"; }

      // ~ other

      // not sure if there's a way to query current cursor position
      // there's defo no builtin way to move the cursor, but it can be done with dotool instead
      Mod+Z { spawn "wl-kbptr" "-o" "modes=floating,click"; }
      Mod+Shift+Z { spawn "wl-kbptr" "-o" "modes=floating,click" "-o" "mode_click.button=right"; }
      Mod+Alt+Z { spawn "wl-kbptr" "-o" "modes=floating,click" "-o" "mode_click.button=middle"; }

    }
    ''
    ;

}
