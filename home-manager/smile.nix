{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.smile ];

  systemd.user.services.smile = {
    Unit = {
      Description = "smile emoji picker";
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${lib.getExe pkgs.smile} --start-hidden";
    Service.Restart = "on-failure";
  };
}
