{ lib, pkgs, ... }:

{
  systemd.user.services.hyprland-per-window-layout = {
    Unit = {
      Description = "Hyprland per-window layouts daemon";
      PartOf = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
    Service.ExecStart = "${lib.getExe pkgs.hyprland-per-window-layout}";
  };

  systemd.user.services.hyprland-helpers = {
    Unit = {
      Description = "My Hyprland helpers";
      PartOf = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
    Service.ExecStart = "${lib.getExe pkgs.bun} ${./HyprHelpers/HyprHelpers.ts}";
  };

  systemd.user.services.hyprscroller-mode-monitor = {
    Unit = {
      Description = "hyprscroller mode state monitor";
      PartOf = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
    Service.ExecStart =
      let
        script = pkgs.writers.writeDashBin "hyprscroller-monitor"
          ''
          hyprsock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
          socat -U - "UNIX-CONNECT:$hyprsock" | while read -r line; do
            case "$line" in
              'scroller>>mode, '*)
                printf '%s' "''${line#scroller>>mode, }" >$XDG_STATE_HOME/hyprscroller-mode
            esac
          done
          '';
      in
        "${lib.getExe script}";
  };
}

