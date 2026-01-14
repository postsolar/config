{ pkgs, ... }:

{
  home.packages = [
    pkgs.kitty
  ];

  xdg.configFile = {
    "kitty/kitty.conf".text =
      # shell fake highlight for treesitter
      ''
      # shell /run/current-system/sw/bin/fish

      macos_option_as_alt left
      macos_titlebar_color background

      # TODO: fonts

      font_size 12.0

      underline_hyperlinks always
      url_style straight

      # ~ cursor

      cursor_blink_interval 0

      # ~ scrolling

      # TODO maybe just make infinite
      scrollback_lines 20000
      scrollback_fill_enlarged_window yes

      # touch_scroll_multiplier 8.0

      # ~ misc

      listen_on unix:/Users/alan/.local/state/kitty/kitty.sock
      allow_remote_control yes

      # unintended behavior in tiled environments
      remember_window_size no

      paste_actions quote-urls-at-prompt
      enable_audio_bell no
      dynamic_background_opacity yes
      notify_on_cmd_finish unfocused 15

      # ~ colors

      background_opacity 0.85

      selection_foreground none
      selection_background none

      # cursor #ffffff
      # cursor_text_color #000000
      # url_color #FFD700

      # black
      color0 #2b2b2b
      color8 #666666
      # red
      color1 #d36265
      color9 #ef8171
      # green
      color2  #aece91
      color10 #cfefb3
      # yellow
      color3  #e7e18c
      color11 #fff796
      # blue
      color4  #5297cf
      color12 #74b8ef
      # magenta
      color5  #963c59
      color13 #b85e7b
      # cyan
      color6  #5e7175
      color14 #a3babf
      # white
      color7  #bebebe
      color15 #ffffff

      # TODO: keybinds

      # ~ extra dynamic configuration

      include ~/.config/kitty/overrides.conf
      '';
  };
}
