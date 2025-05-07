{ lib, config, ... }:

let
  inherit (config) theme;
  unhash = lib.strings.removePrefix "#";

  main = {
    font = "monospace:size=11";
    pad = "0x0 center";
  };

  scrollback = {
    lines = 20000;
    multiplier = 8;
  };

  url = {
    osc8-underline = "always";
    label-letters = "qwfarsxcd";
  };

  colors = builtins.mapAttrs (_: v: if builtins.isString v then unhash v else v) {
    foreground = theme.colors.terminalForeground;
    background = theme.colors.terminalBackground;
    regular0   = theme.colors.terminalRegular0;
    regular1   = theme.colors.terminalRegular1;
    regular2   = theme.colors.terminalRegular2;
    regular3   = theme.colors.terminalRegular3;
    regular4   = theme.colors.terminalRegular4;
    regular5   = theme.colors.terminalRegular5;
    regular6   = theme.colors.terminalRegular6;
    regular7   = theme.colors.terminalRegular7;
    bright0    = theme.colors.terminalBright0;
    bright1    = theme.colors.terminalBright1;
    bright2    = theme.colors.terminalBright2;
    bright3    = theme.colors.terminalBright3;
    bright4    = theme.colors.terminalBright4;
    bright5    = theme.colors.terminalBright5;
    bright6    = theme.colors.terminalBright6;
    bright7    = theme.colors.terminalBright7;
    alpha = 0.9;
    # selection-foreground
    # selection-background
    # jump-labels
    # scrollback-indicator
    # search-box-no-match
    # search-box-match
    # urls
  };

  key-bindings = {
    noop = "none";

    # up-page and down-page are the defaults
    # leaving them here just as a reminder
    scrollback-up-page        = "Shift+Page_Up";
    scrollback-up-half-page   = "Control+Mod1+Up";
    scrollback-up-line        = "Control+Up";
    scrollback-down-page      = "Shift+Page_Down";
    scrollback-down-half-page = "Control+Mod1+Down";
    scrollback-down-line      = "Control+Down";
    scrollback-home           = "Control+Home";
    scrollback-end            = "Control+End";

    clipboard-copy            = "Control+c";
    clipboard-paste           = "Control+Shift+v";
    primary-paste             = "Control+v";

    search-start              = "Control+slash Control+f";

    # pipe-visible            = "[${piper'} visible]        Control+e";
    # pipe-scrollback         = "[${piper'} scrollback]     Control+Shift+e";
    # pipe-selected           = "[${piper'} selected]       Control+Mod1+e";
    # pipe-command-output     = "[${piper'} command-output] Control+period";

    show-urls-launch          = "Control+u";
    show-urls-persistent      = "Control+Shift+u";
    show-urls-copy            = "Control+Mod1+u";

    prompt-prev               = "Control+Shift+Up";
    prompt-next               = "Control+Shift+Down";

    unicode-input             = "none";
  };

  search-bindings = {
    cancel                             = "Escape";
    find-next                          = "Control+n";
    find-prev                          = "Control+Shift+n Control+Mod1+n";

    cursor-left                        = "Left";
    cursor-left-word                   = "Mod1+Left";
    cursor-right                       = "Right";
    cursor-right-word                  = "Mod1+Right";
    cursor-home                        = "Control+Left Home";
    cursor-end                         = "Control+Right End";

    extend-to-word-boundary            = "Mod1+Shift+Right";
    extend-backward-to-word-boundary   = "Mod1+Shift+Left";
    extend-to-next-whitespace          = "Mod1+Shift+w";
    extend-backward-to-next-whitespace = "Mod1+Shift+q";

    clipboard-paste                    = "Control+Shift+v";
    primary-paste                      = "Control+v";

    scrollback-up-half-page            = "Control+Mod1+Up";
    scrollback-up-line                 = "Control+Up";

    scrollback-down-half-page          = "Control+Mod1+Down";
    scrollback-down-line               = "Control+Down";

    scrollback-home                    = "Control+Home";
    scrollback-end                     = "Control+End";
  };

  mouse-bindings = {
    selection-override-modifiers = "Mod1";
  };

in
  {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        inherit
          main
          scrollback
          url
          colors
          key-bindings
          search-bindings
          mouse-bindings
          ;
      };
    };
  }


