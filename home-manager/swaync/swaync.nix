{ lib, pkgs, ... }:

# TODO: broken for some reason
# TODO: https://github.com/ErikReider/SwayNotificationCenter/pull/529

{

  xdg.configFile."swaync/style.css".source =
    pkgs.runCommandLocal "swaync-styles" {}
      ''${lib.getExe' pkgs.nodePackages.sass "sass"} ${./style.scss} $out''
      ;

  services.swaync = {
    enable = true;
    # INFO: ref: https://github.com/ErikReider/SwayNotificationCenter/raw/refs/heads/main/src/configSchema.json
    settings = {
      cssPriority = "user";
      notification-inline-replies = true;
      notification-icon-size = 32;
      notification-window-width = 400;
      notification-visibility = {};
      control-center-margin-top = 20;
      control-center-margin-bottom = 20;
      control-center-margin-right = 10;
      text-empty = "no notifications";
      widgets = [
        "mpris"
        "volume"
        "inhibitors"
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        volume = {
          show-per-app = true;
          show-per-app-label = true;
          label = "  ";
          empty-list-label = "no active sink input";
        };
        inhibitors = {
          button-text = "clear all";
          text = "inhibitors";
        };
        title = {
          button-text = "clear all";
          text = "notifications";
        };
        dnd = {
          text = "do not disturb";
        };
      };
    };
  };

}

