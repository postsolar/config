{ config, lib, pkgs, ... }:

let

  cfg = { inherit (config.services) dotool ydotool; };

  dotoolDeps = lib.makeBinPath [ pkgs.coreutils pkgs.procps ];

  enableEither = cfg.dotool.enable || cfg.ydotool.enable;

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

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        defaultText = literalExpression "[]";
        description = "Which users {command}`dotool` will be enabled for.";
      };

    };

    services.ydotool = with lib; {

      enable = mkEnableOption "ydotool";

      package = mkOption {
        type = types.package;
        default = pkgs.ydotool;
        defaultText = literalExpression "pkgs.ydotool";
        description = "Package providing {command}`ydotool`.";
      };

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        defaultText = literalExpression "[]";
        description = "Which users {command}`ydotool` will be enabled for.";
      };

    };

  };

  config = {

    hardware.uinput.enable = lib.mkDefault enableEither;

    services.udev.extraRules = lib.mkIf enableEither ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';

    users.groups.input = lib.mkIf enableEither {};

    users.users =
      lib.attrsets.genAttrs
        (cfg.dotool.users ++ cfg.ydotool.users)
        (_: { extraGroups = [  "uinput" "input" ]; })
      ;

    environment.systemPackages =
      lib.optional cfg.dotool.enable cfg.dotool.package
        ++ lib.optional cfg.ydotool.enable cfg.ydotool.package
      ;

    systemd.user.services.dotoold = lib.mkIf cfg.dotool.enable {
      unitConfig = {
        Description = "dotool - uinput tool";
        Documentation = [ "https://git.sr.ht/~geb/dotool/tree/HEAD/doc/dotool.1.scd" ];
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
      };
      serviceConfig = {
        Environment = [ "PATH=$PATH:${dotoolDeps}" ];
        ExecStart = "${cfg.dotool.package}/bin/dotoold";
        Restart = "always";
        RestartSec = 10;
      };
      wantedBy = [ "graphical-session.target" ];
    };

    # TODO could maybe be removed because ydotool
    # ships their own service
    systemd.user.services.ydotoold = lib.mkIf cfg.ydotool.enable {
      unitConfig = {
        Description = "An auto-input utility for wayland";
        Documentation = [ "man:ydotool(1)" "man:ydotoold(8)" ];
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
      };
      serviceConfig = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-own=1000:100";
        Restart = "always";
        RestartSec = 10;
      };
      wantedBy = [ "graphical-session.target" ];
    };

  };
}

