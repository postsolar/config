{ lib, config, pkgs, ... }:

let

  piper = pkgs.writeZshApplication {
    name = "foot piper";
    text =
      ''
      tmp=''${ mktemp }
      cat > $tmp
      foot -a '-float -center -wh60' $EDITOR -- $tmp
      rm -f -- $tmp
      '';
  };

  piper' = lib.strings.escapeShellArg (lib.getExe piper);

  # filter an attribute set recursively and keep only non-null values
  filterNonNullRecursive =
    lib.attrsets.filterAttrsRecursive (_: v: v != null);

  themeColors = config.theme.colorsNoPrefix;

  # configuration sections

  main = {
    shell = config.home.homeDirectory + "/.local/bin/fish";

    # font = "Ellograph CF:fontfeatures=+ss04:fontfeatures=+liga:size=11";
    font = "MonoLisa:size=11";

    underline-offset = "2px";
    underline-thickness = "1px";

    pad = "0x0 center";
    notify-focus-inhibit = "no";
  };

  colors =
    rec {
      foreground           = themeColors.foreground;
      background           = themeColors.background;
      regular0             = themeColors.color0;
      regular1             = themeColors.color1;
      regular2             = themeColors.color2;
      regular3             = themeColors.color3;
      regular4             = themeColors.color4;
      regular5             = themeColors.color5;
      regular6             = themeColors.color6;
      regular7             = themeColors.color7;
      bright0              = themeColors.color8;
      bright1              = themeColors.color9;
      bright2              = themeColors.color10;
      bright3              = themeColors.color11;
      bright4              = themeColors.color12;
      bright5              = themeColors.color13;
      bright6              = themeColors.color14;
      bright7              = themeColors.color15;
      selection-foreground = themeColors.selection_fg or background;
      selection-background = themeColors.selection_bg or foreground;
      jump-labels          = regular0 + " " + bright2;
      scrollback-indicator = regular0 + " " + bright0;
      search-box-no-match  = foreground + " " + regular7;
      search-box-match     = bright7 + " " + regular0;
      urls                 = bright6;
      flash                = bright6;
    };

  # doesn't seem to be worth setting, default is much more powerful
  # because it uses invert attribute dynamically
  cursor = {};

  environment = {};

  bell = {};

  scrollback = {
    lines = 20000;
    multiplier = 8;
  };

  url = {
    osc8-underline = "always";
    label-letters = "qwfars<xcdptvbgzjmk";
  };

  mouse = {
    hide-when-typing = "yes";
    alternate-scroll-mode = "yes";
  };

  touch = {};

  csd = {};

  key-bindings = {
    noop = "none";

    font-increase = "Control+plus Control+equal Control+KP_Add";
    font-decrease = "Control+minus Control+KP_Subtract";
    font-reset    = "Control+0 Control+KP_0";

    scrollback-up-page                 = "Shift+Page_Up";
    scrollback-up-half-page            = "Control+Mod1+Up";
    scrollback-up-line                 = "Control+Up";
    scrollback-down-page               = "Shift+Page_Down";
    scrollback-down-half-page          = "Control+Mod1+Down";
    scrollback-down-line               = "Control+Down";
    scrollback-home                    = "Control+Home";
    scrollback-end                     = "Control+End";

    clipboard-copy                     = "Control+c";
    clipboard-paste                    = "Control+Shift+v";
    primary-paste                      = "Control+v";

    search-start                       = "Control+Shift+s";

    pipe-visible                       = "[${piper'} visible]        Control+e";
    pipe-scrollback                    = "[${piper'} scrollback]     Control+Shift+e";
    pipe-selected                      = "[${piper'} selected]       Control+Mod1+e";
    pipe-command-output                = "[${piper'} command-output] Control+period";

    show-urls-launch                   = "Control+Mod1+u";
    show-urls-copy                     = "Control+Shift+u";
    show-urls-persistent               = "Control+Mod1+Shift+u";

    prompt-prev                        = "Control+Shift+a";
    prompt-next                        = "Control+Shift+x";

    # apparently this disables kanata's unicode input.
    # although its implemented in a way that it wont work consistently
    # across different apps anyways so not sure if it's worth preserving.
    # a better solution would be to open an issue to handle unicode
    # input via XCompose as it's done in keyd (and kmonad?)
    unicode-input                      = "none";
  };

  search-bindings = {
    cancel                             = "Escape";
    commit                             = "Return";
    find-next                          = "Control+n";
    find-prev                          = "Control+Shift+n Control+Mod1+n";

    cursor-left                        = "Left";
    cursor-left-word                   = "Mod1+Left";
    cursor-right                       = "Right";
    cursor-right-word                  = "Mod1+Right";
    cursor-home                        = "Control+Left Home";
    cursor-end                         = "Control+Right End";

    delete-prev                        = "BackSpace";
    delete-prev-word                   = "Mod1+BackSpace Control+BackSpace";
    delete-next                        = "Delete";
    delete-next-word                   = "Mod1+d Control+Delete";

    extend-char                        = "Shift+Right";
    extend-to-word-boundary            = "Control+w Control+Shift+Right Mod1+Shift+Right";
    extend-to-next-whitespace          = "Control+Shift+w Shift+space";
    extend-backward-char               = "Shift+Left";
    extend-backward-to-word-boundary   = "Control+Shift+Left Mod1+Shift+Left";
    extend-backward-to-next-whitespace = "Mod1+Shift+space";
    extend-line-down                   = "Shift+Down";
    extend-line-up                     = "Shift+Up";

    clipboard-paste                    = "Control+Mod1+v";
    primary-paste                      = "Control+v";

    unicode-input                      = "none";

    scrollback-up-page                 = "Shift+Page_Up";
    scrollback-up-half-page            = "Control+Mod1+Up";
    scrollback-up-line                 = "Control+Up";

    scrollback-down-page               = "Shift+Page_Down";
    scrollback-down-half-page          = "Control+Mod1+Down";
    scrollback-down-line               = "Control+Down";

    scrollback-home                    = "Control+Home";
    scrollback-end                     = "Control+End";
  };

  url-bindings = {
    cancel = "Escape";
    toggle-url-visible = "t";
  };

  text-bindings = {
    # disabled because it messes with handling of kitty
    # keyboard protocol and the only reason for enabling them
    # was the apps which don't implement this protocol in the first place

    # # backspace
    # # 12 is chosen arbitrarily because `Enter` is 13
    # "\\x1b[27;2;12~"  = "Shift+BackSpace";
    # "\\x1b[27;4;12~"  = "Mod1+Shift+BackSpace";
    # "\\x1b[27;6;12~"  = "Control+Shift+BackSpace";
    # "\\x1b[27;8;12~"  = "Control+Mod1+Shift+BackSpace";

    # # space
    # # 14 is chosen on the same grounds
    # "\\x1b[[27;2;14~" = "Shift+space";
    # "\\x1b[[27;4;14~" = "Mod1+Shift+space";
    # "\\x1b[[27;6;14~" = "Control+Shift+space";
    # "\\x1b[[27;8;14~" = "Control+Mod1+Shift+space";

    # # c-{1..0}
    # "^[[27;5;49~" = "Control+1";
    # "^[[27;5;50~" = "Control+2";
    # "^[[27;5;51~" = "Control+3";
    # "^[[27;5;52~" = "Control+4";
    # "^[[27;5;53~" = "Control+5";
    # "^[[27;5;54~" = "Control+6";
    # "^[[27;5;55~" = "Control+7";
    # "^[[27;5;56~" = "Control+8";
    # "^[[27;5;57~" = "Control+9";
    # # "^[[27;5;58~" = "Control+0"; # getting a warning about it being mapped to font-reset

    # # c-a-{1..0}
    # "^[[27;7;49~" = "Control+Mod1+1";
    # "^[[27;7;50~" = "Control+Mod1+2";
    # "^[[27;7;51~" = "Control+Mod1+3";
    # "^[[27;7;52~" = "Control+Mod1+4";
    # "^[[27;7;53~" = "Control+Mod1+5";
    # "^[[27;7;54~" = "Control+Mod1+6";
    # "^[[27;7;55~" = "Control+Mod1+7";
    # "^[[27;7;56~" = "Control+Mod1+8";
    # "^[[27;7;57~" = "Control+Mod1+9";
    # "^[[27;7;58~" = "Control+Mod1+0";

    # # grave / tilde
    # "^`"   = "Control+grave";
    # "^[^`" = "Control+Mod1+grave";
    # "^~"   = "Control+asciitilde";
    # "^[^~" = "Control+Mod1+asciitilde";
  };

  mouse-bindings = {
    selection-override-modifiers = "Mod1";
  };

in

{
  programs.foot = {

    enable = true;

    # vendored systemd service doesn't work so we just
    # start the server ourselves on WM init
    server.enable = false;

    settings =
      filterNonNullRecursive
        {
          inherit
            main
            colors
            cursor
            environment
            bell
            scrollback
            url
            mouse
            touch
            csd
            key-bindings
            search-bindings
            url-bindings
            text-bindings
            mouse-bindings
            ;
        };

  };
}
