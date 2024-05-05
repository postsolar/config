{ inputs, system, pkgs, ... }:

let

  lock = pkgs.writeShellScript "hypridle-lock" ''
    hyprctl dispatch dpms off
  '';

  unlock = pkgs.writeShellScript "hypridle-unlock" ''
    hyprctl dispatch dpms on
  '';

in

{
  home.packages = [ inputs.hypridle.packages.${system}.hypridle ];

  xdg.configFile."hypr/hypridle.conf".text =
    # hyprlang
    ''
    general {
      lock_cmd            = /usr/bin/env true    # dbus/sysd lock command (loginctl lock-session)
      unlock_cmd          = /usr/bin/env true    # same as above, but unlock
      before_sleep_cmd    = /usr/bin/env true    # command ran before sleep
      after_sleep_cmd     = /usr/bin/env true    # command ran after sleep
      ignore_dbus_inhibit = false                # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
    }

    listener {
      timeout    = 780
      on-timeout = notify-send activity "going idle in 2 minutes"
    }
    listener {
      timeout    = 900
      on-timeout = ${lock}
      on-resume  = ${unlock}
    }
    listener {
      timeout    = 1800
      on-timeout = systemctl suspend
    }
    '';
}

