{ config, lib, pkgs, ... }:

let
  cfg = config.services.dotool;
  deps = [ pkgs.coreutils pkgs.procps ];
in

{
  options = {

    services.dotool = with lib; {

      enable = mkEnableOption "dotool";

      package = mkOption {
        type = types.package;
        default = pkgs.dotool;
        defaultText = literalExpression "pkgs.dotool";
        description = "Package providing {command}`dotool`.";
      };

    };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.dotoold = {
      description = "dotoold - dotool daemon";
      wantedBy = [ "multi-user.target" ];
      partOf = [ "multi-user.target" ];
      serviceConfig = {
        Environment = [
          "PATH=$PATH:${ lib.makeBinPath deps }"
          "DOTOOL_PIPE=/run/dotool-pipe"
        ];
        ExecStart = "${lib.getExe' cfg.package "dotoold"}";
      };
    };

    # may be unnecessary

    # hardware.uinput.enable = true;

    # services.udev.extraRules = ''
    #   KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    # '';

    # users.groups.input = {};

    # users.users =
    #   lib.attrsets.genAttrs
    #     (cfg.dotool.users)
    #     (_: { extraGroups = [  "uinput" "input" ]; })
    #   ;

  };
}
