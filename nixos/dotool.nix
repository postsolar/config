{ config, lib, pkgs, ... }:

let
  dotool = pkgs.dotool;
  deps = [ pkgs.coreutils pkgs.procps ];
in

{
  # set up dotool

  environment.systemPackages = [ dotool ];

  environment.sessionVariables = {
    DOTOOL_PIPE = "/run/dotool-pipe";
  };

  systemd.services.dotoold = {
    description = "dotoold - dotool daemon";
    wantedBy = [ "multi-user.target" ];
    partOf = [ "multi-user.target" ];
    serviceConfig = {
      Environment = [
        "PATH=$PATH:${ lib.makeBinPath deps }"
        "DOTOOL_PIPE=${config.environment.sessionVariables.DOTOOL_PIPE}"
      ];
      ExecStart = "${lib.getExe' dotool "dotoold"}";
    };
  };

  # and also add ydotool

  programs.ydotool.enable = true;
  programs.ydotool.group = "input";

}
