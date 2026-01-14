{ pkgs, config, flakeDir, ... }:

{
  home.packages = [
    pkgs.kanata-with-cmd
  ];

  launchd.agents.kanata = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/sudo"
        "-n"
        "/run/current-system/sw/bin/kanata"
        "--cfg"
        "${flakeDir}/home-manager/kanata/kanata.kbd"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/kanata.log";
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/kanata.log";
    };
  };
}
