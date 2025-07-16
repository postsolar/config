{ lib, pkgs, ... }:

{
  home.packages = [
    pkgs.wl-clipboard
    pkgs.wl-clip-persist
    pkgs.copyq
  ];

  services = {
    copyq = {
      enable = true;
      forceXWayland = false;
    };
  };

  systemd.user.services.wl-clip-persist = {
    Unit = {
      Description = "Persistent clipboard for Wayland";
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard regular";
  };
}

