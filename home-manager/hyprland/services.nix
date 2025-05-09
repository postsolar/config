{ config, lib, pkgs, ... }:

{
  # fixme: broken? idk what's wrong with it
  #
  # systemd.user.services.hyprland-per-window-layout = {
  #   Unit = {
  #     Description = "Hyprland per-window layouts daemon";
  #     Requires = [ "hyprland-session.target" ];
  #     PartOf = [ "hyprland-session.target" ];
  #     After = [ "hyprland-session.target" ];
  #   };
  #   Install.WantedBy = [ "hyprland-session.target" ];
  #   Service.ExecStart = "${lib.getExe pkgs.hyprland-per-window-layout}";
  # };

  systemd.user.services.hyprland-helpers = {
    Unit = {
      Description = "My Hyprland helpers";
      Requires = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
    Service.ExecStart = "${lib.getExe pkgs.bun} ${./HyprHelpers/HyprHelpers.ts}";
  };
}

