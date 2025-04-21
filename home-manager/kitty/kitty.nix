{ pkgs, config, ... }:

let

  inherit (config.theme) colors;

in

{

  home.packages = [
    pkgs.kitty
  ];

  xdg.configFile = {
    "kitty/kitty.conf".text =
      # bash
      ''
      source ~/.config/kitty/ovverides.conf

      # ~ fonts

      font_size 10.0

      text_composition_strategy legacy

      modify_font underline_position +3
      modify_font underline_thickness 1px

      underline_hyperlinks always
      url_style straight

      # ~ cursor

      cursor_blink_interval 0

      # ~ scrolling

      scrollback_lines 20000
      scrollback_fill_enlarged_window yes

      touch_scroll_multiplier 8.0

      # ~ misc

      # this will be expanded to unix:$XDG_STATE_HOME/kitty/kitty.sock-{{kitty_pid}} and made available as $KITTY_LISTEN_ON
      # a better choice would be $XDG_RUNTIME_DIR, but 1) kitty won't create it itself 2) nixos-rebuild will erase it
      listen_on unix:$XDG_STATE_HOME/kitty/kitty.sock
      allow_remote_control yes

      # unintended behavior in tiled environments
      remember_window_size no

      paste_actions quote-urls-at-prompt
      enable_audio_bell no
      dynamic_background_opacity yes
      notify_on_cmd_finish unfocused 15

      # ~ colors

      background_opacity 0.9

      selection_foreground none
      selection_background none

      # cursor #ffffff
      # cursor_text_color #000000
      # url_color #FFD700

      # black
      color0 ${colors.terminalRegular0}
      color8 ${colors.terminalBright0}
      # red
      color1 ${colors.terminalRegular1}
      color9 ${colors.terminalBright1}
      # green
      color2  ${colors.terminalRegular2}
      color10 ${colors.terminalBright2}
      # yellow
      color3  ${colors.terminalRegular3}
      color11 ${colors.terminalBright3}
      # blue
      color4  ${colors.terminalRegular4}
      color12 ${colors.terminalBright4}
      # magenta
      color5  ${colors.terminalRegular5}
      color13 ${colors.terminalBright5}
      # cyan
      color6  ${colors.terminalRegular6}
      color14 ${colors.terminalBright6}
      # white
      color7  ${colors.terminalRegular7}
      color15 ${colors.terminalBright7}

      # ~ keybinds

      # refs:
      # https://sw.kovidgoyal.net/kitty/actions/
      # https://sw.kovidgoyal.net/kitty/conf/#keyboard-shortcuts
      # https://sw.kovidgoyal.net/kitty/kittens/hints/
      # https://sw.kovidgoyal.net/kitty/open_actions/
      # `kitty @ --help`

      clear_all_shortcuts yes
      kitty_mod ctrl+alt

      # aliases

      action_alias launch_os_win  launch --type=os-window --cwd=current
      action_alias launch_overlay launch --type=overlay --cwd=current

      # [s]crollback opening

      map kitty_mod+s>a       launch_overlay --stdin-source @screen_scrollback --stdin-add-formatting $PAGER
      map kitty_mod+s>shift+a launch_overlay --stdin-source @screen_scrollback $EDITOR
      map kitty_mod+s>c       launch_overlay --stdin-source @last_cmd_output --stdin-add-formatting $PAGER
      map kitty_mod+s>shift+c launch_overlay --stdin-source @last_cmd_output $EDITOR
      map kitty_mod+s>v       launch_overlay --stdin-source @last_visited_cmd_output --stdin-add-formatting $PAGER
      map kitty_mod+s>shift+v launch_overlay --stdin-source @last_visited_cmd_output $EDITOR

      # [h]ints
      # idk why but xdg-open behaves weird here specifically
      # many of these are ultimately opened via kitty +open, which is itself configured via launch-action.conf
      map kitty_mod+h>u       open_url_with_hints
      map kitty_mod+h>y       kitten hints --type hyperlink --program "handlr open"
      map kitty_mod+h>shift+y kitten hints --type hyperlink --program -
      map kitty_mod+h>f       kitten hints --type path --program -
      map kitty_mod+h>shift+f kitten hints --type path --program "handlr open"
      map kitty_mod+h>l       kitten hints --type line --program -
      map kitty_mod+h>w       kitten hints --type word --program -
      map kitty_mod+h>h       kitten hints --type hash --program -
      map kitty_mod+h>n       kitten hints --type linenum $EDITOR {path}:{line}
      map kitty_mod+o         pass_selection_to_program handlr open

      # [w]indow controls

      map kitty_mod+w>n launch_os_win
      map kitty_mod+w>d detach_window ask

      # copy, paste

      map ctrl+c copy_or_interrupt
      map ctrl+v paste_from_selection
      map kitty_mod+v paste_from_clipboard

      # scrolling and scrollback

      map kitty_mod+home       scroll_home
      map kitty_mod+end        scroll_end
      map kitty_mod+up         scroll_to_prompt -1
      map kitty_mod+down       scroll_to_prompt 1
      map kitty_mod+a          scroll_to_prompt 0
      map ctrl+l               clear_terminal scroll active
      map ctrl+shift+l         combine : clear_terminal scrollback active : clear_terminal to_cursor active

      # appearance

      map kitty_mod+equal       change_font_size current +1.0
      map kitty_mod+plus        change_font_size current +1.0
      map kitty_mod+kp_add      change_font_size current +1.0
      map kitty_mod+minus       change_font_size current -1.0
      map kitty_mod+kp_subtract change_font_size current -1.0
      map kitty_mod+0           change_font_size current 0
      map kitty_mod+a>m         set_background_opacity +0.02
      map kitty_mod+a>l         set_background_opacity -0.02
      map kitty_mod+a>1         set_background_opacity 1
      map kitty_mod+a>d         set_background_opacity default

      # meta and misc

      map kitty_mod+u        kitten unicode_input
      map kitty_mod+escape   kitty_shell window
      '';

    "kitty/open-actions.conf".text =
      ''
      # Open any image in the full kitty window by clicking on it
      protocol file
      mime image/*
      action launch --type=overlay kitten icat --hold -- ''${FILE_PATH}

      # Open directories in lf
      protocol file
      mime inode/directory
      action launch --type=os-window lf -- ''${FILE_PATH}
      '';
  };
}

