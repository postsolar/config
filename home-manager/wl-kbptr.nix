{ config, lib, pkgs, ... }:

{
  # note that config takes precedence over commandline args, so certain things
  # that would usually be specified via the commandline are commented out
  xdg.configFile."wl-kbptr/config".text =
    let
      white = "ffffff";
      hotpink = "ff69b4";
      hotpink-but-darker = "cf0068";
      pinkish-black = "17000c";
      red = "ee2222";
      grey = "333333";
      dark-grey = "222222";
      dark-blue = "000033";
    in
    # ini
    ''
    [general]
    home_row_keys=
    # modes=tile,bisect

    [mode_tile]
    label_color=#${white}dd
    label_select_color=#${hotpink}dd
    unselectable_bg_color=#${pinkish-black}20
    selectable_bg_color=#${hotpink}44
    selectable_border_color=#${hotpink}cc
    label_font_family=sans-serif
    label_symbols=abcdefghijklmnopqrstuvwxyz

    [mode_floating]
    source=detect
    label_color=#${white}ff
    label_select_color=#${hotpink}ff
    unselectable_bg_color=#${pinkish-black}20
    selectable_bg_color=#${hotpink}88
    selectable_border_color=#${hotpink}ff
    label_font_family=monospace
    label_symbols=qwydsazxc

    [mode_bisect]
    label_color=#${white}dd
    label_font_size=20
    label_font_family=sans-serif
    label_padding=-20
    pointer_size=24
    pointer_color=#${red}dd
    unselectable_bg_color=#${dark-grey}66
    even_area_bg_color=#${hotpink}55
    even_area_border_color=#${hotpink-but-darker}88
    odd_area_bg_color=#${dark-blue}44
    odd_area_border_color=#${dark-blue}88
    history_border_color=#${grey}99

    [mode_click]
    # button=left
    '';
}

