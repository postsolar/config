{ inputs, lib, pkgs, system, config, flakeDir, ... }:

let
  walker = inputs.walker.packages.${system}.walker;
  link = f: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home-manager/walker/${f}";
in

{
  home.packages = [
    walker
    # for `calc` module
    pkgs.libqalculate
  ];

  systemd.user.services.walker = {
    Unit.Description = "Walker multi-purpose launcher gapplication service";
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${lib.getExe walker} --gapplication-service";
    # https://github.com/abenz1267/walker/issues/258
    Service.Environment = [ "GTK_IM_MODULE=fcitx" ];
    Service.Restart = "on-failure";
  };

  xdg.configFile."walker/config.toml".source = link "config.toml";
  xdg.configFile."walker/themes/black.css".source = link "black.css";
  xdg.configFile."walker/themes/black.toml".source = link "black.toml";
}

