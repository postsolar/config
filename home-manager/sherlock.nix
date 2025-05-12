{ config, pkgs, ... }:

let package = pkgs.sherlock-launcher; in

{

  home.packages = [
    package
  ];

  # daemonizing currently doesn't work with stdin input, disable it for now
  # systemd.user.services.sherlock-daemon = {
  #   Unit = {
  #     Description = "Sherlock: a versatile application/command launcher for Wayland";
  #     Documentation = "https://github.com/Skxxtz/sherlock/tree/main/docs";
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service = {
  #     ExecStart = "${lib.getExe package}";
  #   };
  # };

  xdg.configFile = {
    "sherlock/config.toml".text = # toml
      ''
      [default_apps]

      [appearance]
      width      =   600
      height     =   400
      icon_paths =   [ "${config.xdg.configHome}/sherlock/icons" ]

      [behavior]
      # cache doesn't get invalidated upon desktop entry change, which for
      # packages installed with Nix means outdated or missing paths in Exec= lines of desktop entries
      # https://github.com/Skxxtz/sherlock/issues/65
      caching    =   false
      # daemonizing prevents stdin input from working
      # daemonize  =   true

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
      Fcitx5*
      fish*
      Advanced Network Configuration
      '';
  };
}

