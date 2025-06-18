{ config, pkgs, lib, ... }:

let package = pkgs.sherlock-launcher; in

{

  home.packages = [
    package
  ];

  # stdin input works with daemonized mode in v0.1.13
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

  xdg.configFile = {
    "sherlock/config.toml".text = # toml
      ''
      [default_apps]

      [appearance]
      width      =   600
      height     =   400
      icon_paths =   [ "${config.xdg.configHome}/sherlock/icons" ]

      [behavior]
      # cache will get invalidated upon desktop entry change in v0.1.13
      # https://github.com/Skxxtz/sherlock/issues/65
      caching    =   true
      daemonize  =   true

      [binds]
      prev       =   "None"
      next       =   "None"
      modifier   =   "alt"

      [files]
      css = "/dev/null"
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
          "priority": 3
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
      Fcitx5*
      fish*
      Advanced Network Configuration
      '';
  };
}

