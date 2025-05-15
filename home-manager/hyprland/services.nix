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
}

