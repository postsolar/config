{ inputs, pkgs, lib, config, ... }:

let

  paneruConfig = # toml
    ''
    # Example configuration for Paneru.
    #
    [options]
    # Enables focus follows mouse. Enabled by default, set to false to disable.
    focus_follows_mouse = false

    # Enables mouse follows focus. Enabled by default, set to false to disable.
    mouse_follows_focus = false

    # Array of widths used by the `window_resize` action to cycle between.
    # Defaults to 25%, 33%, 50%, 66% and 75%.
    preset_column_widths = [ 0.25, 0.33, 0.50, 0.66, 0.75, 0.9 ]

    # How many fingers to use for moving windows left and right.
    # Make sure that it doesn't clash with OS setting for workspace switching.
    # Values lower than 3 will be ignored.
    # Remove the line to disable the gesture feature.
    # Apple touchpads support gestures with more than five fingers (!),
    # but it is probably not that useful to use two hands :)
    swipe_gesture_fingers = 4

    # Window movement speed in pixels/second.
    # To disable animations, leave this unset or set to a very large value.
    animation_speed = 2000

    [bindings]
    # Moves the focus between windows.
    window_focus_west = "cmd - h"
    window_focus_east = "cmd - l"
    window_focus_north = "cmd - k"
    window_focus_south = "cmd - j"

    # Swaps windows in chosen direction.
    window_swap_west = "alt - h"
    window_swap_east = "alt - l"

    # Jump to the left-most or right-most windows.
    window_focus_first = "cmd + shift - h"
    window_focus_last = "cmd + shift - l"

    # Move the current window into the left-most or right-most positions.
    window_swap_first = "alt + shift - h"
    window_swap_last = "alt + shift - l"

    # Centers the current window on screen.
    window_center = "alt - c"

    # Cycles between the window sizes defined in the `preset_column_widths` option.
    window_resize = "alt - r"

    # Toggle full width for the current focused window.
    window_fullwidth = "alt - f"

    # Toggles the window for management. If unmanaged, the window will be "floating".
    window_manage = "ctrl + alt - t"

    # Stacks and unstacks a window into the left column. Each window gets a 1/N of the height.
    window_stack = "alt - ]"
    window_unstack = "alt + shift - ]"

    # Quits the window manager.
    # quit = "ctrl + alt - q"

    # Window properties, matched by a RegExp title string.
    [windows]

    [windows.pip]
    # Title RegExp pattern is required.
    title = "Picture.*(in)?.*[Pp]icture"
    # Do not manage this window, e.g. it will be floating.
    floating = true

    [windows.neovide]
    # Matches an editor and always inserts its window at index 1.
    title = ".*"
    bundle_id = "com.neovide.neovide"
    index = 1
    '';

in

{

  home.packages = [
    inputs.paneru.packages.${pkgs.stdenv.hostPlatform.system}.paneru
  ];

  # pulled from the upstream module
  launchd.agents.paneru = {
    enable = true;
    config = {
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      Label = "Paneru";
      Nice = -20;
      ProcessType = "Interactive";
      EnvironmentVariables = {
        NO_COLOR = "1";
        PANERU_CONFIG = "${config.xdg.configHome}/paneru/paneru.toml";
      };
      RunAtLoad = true;
      StandardOutPath = "/tmp/paneru.log";
      StandardErrorPath = "/tmp/paneru.err.log";
      Program = "${inputs.paneru.packages.${pkgs.stdenv.hostPlatform.system}.paneru}/bin/paneru";
    };
  };

  # why: because 
  home.activation.paneruConfig = lib.hm.dag.entryAfter [ "writeBoundary" ]
    ''
    run mkdir -p ${config.xdg.configHome}/paneru
    run cat > ${config.xdg.configHome}/paneru/paneru.toml <<'EOF'
    ${paneruConfig}
    EOF
    '';

}
