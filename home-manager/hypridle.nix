{ ... }:

let

  warn = {
    timeout = 780;
    on-timeout = "notify-send -e -t 120 -i system -u low -a hypridle Activity 'Going idle in 2 minutes'";
  };

  sleep = {
    timeout = 900;
    on-timeout = # sh
      ''
      case "$XDG_CURRENT_DESKTOP" in
        Hyprland) hyprctl dispatch dpms off ;;
        niri) niri msg action power-off-monitors ;;
      esac
      '';
    on-resume = # sh
      ''
      case "$XDG_CURRENT_DESKTOP" in
        Hyprland) hyprctl dispatch dpms on ;;
        niri) niri msg action power-on-monitors ;;
      esac
      '';
  };

  suspend = {
    timeout = 1800;
    on-timeout = "systemctl suspend";
  };

in

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd               = "/usr/bin/env true";   # dbus/sysd lock command (loginctl lock-session)
        unlock_cmd             = "/usr/bin/env true";   # same as above, but unlock
        before_sleep_cmd       = "/usr/bin/env true";   # command ran before sleep
        after_sleep_cmd        = "/usr/bin/env true";   # command ran after sleep
        ignore_dbus_inhibit    = "false";               # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
        ignore_systemd_inhibit = "false";               # whether to ignore systemd-inhibit --what=idle inhibitors
      };
      listener = [ warn sleep suspend ];
    };
  };
}

