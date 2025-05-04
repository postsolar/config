{ config, lib, pkgs, ... }:

let package = pkgs.sherlock-launcher; in

{
  # TODO: try out sherlock for a few days,
  # and if it works well then remove fuzzel and albert

  home.packages = [
    package
  ];

  systemd.user.services.sherlock-daemon = {
    Unit = {
      Description = "Sherlock: a versatile application/command launcher for Wayland";
      Documentation = "https://github.com/Skxxtz/sherlock/tree/main/docs";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${lib.getExe package}";
    };
  };

  # there's a home-manager module in https://github.com/Skxxtz/sherlock/blob/main/nix/home-manager.nix
  # but it's kinda goofy, i'd just write my files directly here
  xdg.configFile = {
    "sherlock/config.toml".text = # toml
      ''
      [default_apps]

      [appearance]
      width      =   600
      height     =   400
      icon_paths =   [ "${config.xdg.configHome}/sherlock/icons" ]

      [behavior]
      caching    =   true
      daemonize  =   true

      [binds]
      prev       =   "None"
      next       =   "None"
      modifier   =   "alt"

      [files]
      '';

    "sherlock/fallback.json".text = # json
      ''
      [
        {
          "name": "App Launcher",
          "alias": "app",
          "type": "app_launcher",
          "args": {},
          "priority": 2,
          "home": true
        },
        {
          "name": "Calculator",
          "type": "calculation",
          "args": {
            "capabilities": [
              "calc.math",
              "calc.units"
            ]
          },
          "priority": 1
        }
      ]
      '';

    "sherlock/sherlock_alias.json".text = # json
      ''
      {
      }
      '';

    "sherlock/sherlockignore".text =
      ''
      Avahi*
      qt*
      userfeedback*
      '';
  };
}

