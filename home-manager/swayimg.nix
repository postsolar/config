{ config, ... }:

{
  programs.swayimg.settings = {
    list.all = "yes";
    font.name = builtins.head config.theme.fonts.sansSerif;
    font.size = 16;
    font.color = "#ffffff";
    font.background = "#000000aa";
    font.shadow = "#00000000";
    info.show = "no";
    info.info_timeout = 0;
    info.status_timeout = 900;

    "keys.viewer" = {
      Left = "prev_file";
      Right = "next_file";
    };
  };
}
