{ config, inputs, pkgs, ... }:

{

  imports = [
    inputs.niri-flake.homeModules.niri
    # ./config.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    # config = null;
    settings = {
      input = {
        keyboard = {
          xkb = {
            # ref: xkeyboard-config(7)
            layout = "us,ru";
            variant = "colemak_dh_iso,ruu";
            options = "compose:rctrl,grp:win_space_toggle";
            # file = "~/.config/keymap.xkb";
          };
          track-layout = "window";
          # not accepted by current flake version:
          # numlock = true;
        };

        touchpad = {
          tap = true;
          accel-speed = 0.25;
          # not accepted by current flake version:
          # drag = true;
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-factor = 2.0;
        };

        mouse.natural-scroll = true;
        trackpoint.natural-scroll = true;

        workspace-auto-back-and-forth = true;
        warp-mouse-to-focus = true;
        focus-follows-mouse.enable = true;
        # focus-follows-mouse.max-scroll-amount = "0%";
      };

      outputs.eDP-1.enable = false;

      layout = {
        gaps = 24;

        focus-ring = {
          width = 4;
          active.gradient = { from="hotpink"; to="palevioletred"; angle=210; relative-to="workspace-view"; };
        };

        border = {
          enable = false;
          width = 4;
          active.color = "#ffc87f";
          inactive.color = "#505050";
          active.gradient = { from="#ffbb66"; to="#ffc880"; angle=45; relative-to="workspace-view"; };
          inactive.gradient = { from="#505050"; to="#808080"; angle=45; relative-to="workspace-view"; };
        };

        shadow = {
          enable = true;
          # draw-behind-window = true;
          softness = 20;
          spread = 2;
          offset = { x=8; y=8; };
          color = "#00000099";
        };

        tab-indicator = {
          gap = -10;
          position = "bottom";
          gaps-between-tabs = 5;
        };

        # struts = {
        #   left = 4;
        #   right = 4;
        #   top = 8;
        #   bottom = 4;
        # };

        preset-column-widths = [
          { proportion = 0.25; }
          { proportion = 0.33; }
          { proportion = 0.50; }
          { proportion = 0.66; }
          { proportion = 0.75; }
          { proportion = 1.00; }
        ];

        preset-window-heights = [
          { proportion = 0.25; }
          { proportion = 0.33; }
          { proportion = 0.50; }
          { proportion = 0.66; }
          { proportion = 0.75; }
          { proportion = 1.00; }
        ];


      };

      prefer-no-csd = true;

      screenshot-path = "/tmp/Screenshots/%Y.%m.%d %H:%M:%S.png";

      cursor = {
        hide-when-typing = true;
        hide-after-inactive-ms = 3000;
      };

      environment = {};

      animations = {
        slowdown = 2.0;
      };

      window-rules = [
        {
          matches = [ { app-id = "kitty"; } ];
          opacity = 0.95;
        }
        {
          matches = [ { app-id = "^org.telegram.desktop$";} ];
          excludes = [ { title = "^Media viewer$"; } ];
          opacity = 0.95;
          draw-border-with-background = false;
        }
        {
          matches = [
            # firefox PiP
            { app-id = "^firefox$"; title = "^(Picture-in-Picture|Pilt-pildis)$"; }
            # chrome PiP
            { title = "^Pilt pildis$"; }
            # emoji picker
            { app-id = "^it.mijorus.smile$"; }
            # clipboard manager
            { app-id = "^com.github.hluk.copyq$"; }
            # emulate window tags
            { app-id = "\\\\+float"; }
          ];
          open-floating = true;
        }
        {
          matches = [ { app-id = "^swayimg$"; } ];
          open-floating = true;
          focus-ring.enable = false;
          border.enable = false;
          shadow.enable = false;
          max-height = 600;
          max-width = 1200;
        }
      ];

      layer-rules = [
        {
          matches = [
            { namespace = "notification"; }
            { namespace = "swaync-control-center"; }
          ];
          block-out-from = "screencast";
        }
      ];

      binds = with config.lib.niri.actions;
        let
          playerctl = args: {
            allow-when-locked = true;
            action.spawn = [ "playerctl" ] ++ args;
          };
          moveHelpers = args: {
            action.spawn = [ "sh" "${./scripts/move-helpers.sh}" ] ++ args;
          };
          wpctl = args: {
            allow-when-locked = true;
            action.spawn = [ "wpctl" ] ++ args;
          };
        in
        {
          # ~ essential

          "Mod+Q".action = close-window;
          "Mod+Shift+E".action = quit;

          # ~ programs

          "Mod+Return".action = spawn "kitty" "-1"; 
          "Mod+Shift+Return".action = spawn "kitty" "-1" "--class" "kitty +float"; 

          # "Mod+R".action = spawn "albert" "toggle";
          # "Mod+Shift+R".action = spawn "fuzzel";
          "Mod+S".action = spawn "sherlock";
          "Mod+N".action = spawn "swaync-client" "--toggle-panel";

          "Mod+O".action = spawn "copyq" "toggle";
          "Mod+Apostrophe".action = spawn "smile";

          "Print".action = spawn "screenshot";
          "Alt+Print".action = spawn "zsh" "-c" ''
            niri msg action screenshot-window --id $(niri msg --json pick-window | jq .id)
            sleep 0.1
            satty -f /tmp/Screenshots/*(om[1])
          '';

          # ~ hardware controls

          "Mod+Shift+F10".action = power-off-monitors;

          "XF86AudioMute"        = wpctl [ "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
          "F1"                   = wpctl [ "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
          "XF86AudioLowerVolume" = wpctl [ "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" "--limit" "1.5" ];
          "F2"                   = wpctl [ "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" "--limit" "1.5" ];
          "XF86AudioRaiseVolume" = wpctl [ "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" "--limit" "1.5" ];
          "F3"                   = wpctl [ "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" "--limit" "1.5" ];
          "XF86AudioMicMute"     = wpctl [ "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
          "F4"                   = wpctl [ "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

          "XF86AudioPlay"        = playerctl [ "play-pause" ];
          "XF86AudioPause"       = playerctl [ "play-pause" ];
          "XF86AudioStop"        = playerctl [ "stop" ];
          "XF86AudioPrev"        = playerctl [ "previous" ];
          "XF86AudioNext"        = playerctl [ "next" ];
          "Mod+XF86AudioPrev"    = playerctl [ "position" "10-" ];
          "Mod+XF86AudioNext"    = playerctl [ "position" "10+" ];

          # ~ window state

          # fullscreen is kinda broken in the sense it doesn't restore previous column setup 🫠
          # it really just expels the window, maximizes it geometrically and sets internal fullscreen state
          "Mod+F".action = fullscreen-window;
          "Mod+Shift+F".action = toggle-windowed-fullscreen;

          "Mod+P".action = toggle-window-floating;
          "Mod+Shift+P".action = switch-focus-between-floating-and-tiling;

          "Mod+B".action = toggle-window-rule-opacity;

          # ~ focus change

          # broken because doesn't update previous window when, say, a window was closed
          # e.g. open W1, open W2, open W3, close W3 → bind won't toggle between W2 and W1
          "Mod+A".action = focus-window-previous;

          "Mod+Left".action = focus-column-left-or-last;
          "Mod+Right".action = focus-column-right-or-first;

          "Mod+Up".action = focus-window-up;
          "Mod+Down".action = focus-window-down;

          "Mod+Tab".action = focus-workspace-down;
          "Mod+Shift+Tab".action = focus-workspace-up;

          # this one would only be useful with indexed workspace switching though
          "Mod+Grave".action = focus-workspace-previous;

          # ~ movement

          # for movement left/right/up/down:
          # shift: act on a window
          # alt: act on a column

          "Mod+Shift+Left"  = moveHelpers [ "left" ]; 
          "Mod+Shift+Right" = moveHelpers [ "right" ]; 
          "Mod+Shift+Up"    = moveHelpers [ "up" ]; 
          "Mod+Shift+Down"  = moveHelpers [ "down" ]; 

          "Mod+Alt+Left"    = moveHelpers [ "--column" "left" ]; 
          "Mod+Alt+Right"   = moveHelpers [ "--column" "right" ]; 
          "Mod+Alt+Up"      = moveHelpers [ "--column" "up" ]; 
          "Mod+Alt+Down"    = moveHelpers [ "--column" "down" ]; 

          "Mod+BracketLeft".action = consume-window-into-column;
          "Mod+BracketRight".action = expel-window-from-column;

          "Mod+Shift+BracketLeft".action = consume-or-expel-window-right;
          "Mod+Shift+BracketRight".action = consume-or-expel-window-left;

          # column state (and window height)

          "Mod+W".action = toggle-column-tabbed-display;

          # i fail to understand what's the difference between center-column and center-window
          "Mod+C".action = center-column;

          # there doesn't seem to be any difference between window and column width
          # ideally we'd want:
          #   comma - shrink width (cycle backward)
          #   period - expand width (cycle forward)
          #   less (S+comma) - shrink height (cycle backward)
          #   gt (S+period) - expand height (cycle forward)
          # but it's not yet implemented i think. could be fixed by just using a submap though?
          # i don't remember if they're already implemented
          "Mod+Comma".action = switch-preset-window-width;
          "Mod+Period".action = switch-preset-window-height;
          "Mod+Shift+Period".action = reset-window-height;
          "Mod+Slash".action = maximize-column;
          "Mod+Alt+Slash".action = expand-column-to-available-width;

          "Mod+Minus".action = set-window-width "-5%";
          "Mod+Equal".action = set-window-width "+5%";
          "Mod+Alt+Minus".action = set-window-height "-5%";
          "Mod+Alt+Equal".action = set-window-height "+5%";

          # ~ other

          # not sure if there's a way to query current cursor position
          # there's defo no builtin way to move the cursor, but it can be done with dotool instead
          "Mod+Z".action = spawn "wl-kbptr" "-o" "modes=floating,click";
          "Mod+Shift+Z".action = spawn "wl-kbptr" "-o" "modes=floating,click" "-o" "mode_click.button=right";
          "Mod+Alt+Z".action = spawn "wl-kbptr" "-o" "modes=floating,click" "-o" "mode_click.button=middle";

        };
    };
  };

}

