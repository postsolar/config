{ ... }:

let
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

  colors = {
    foreground = "ffffff";
    background = "000000";

    regular0   = "2b2b2b";
    regular1   = "d36265";
    regular2   = "aece91";
    regular3   = "e7e18c";
    regular4   = "5297cf";
    regular5   = "963c59";
    regular6   = "5e7175";
    regular7   = "bebebe";

    bright0    = "666666";
    bright1    = "ef8171";
    bright2    = "cfefb3";
    bright3    = "fff796";
    bright4    = "74b8ef";
    bright5    = "b85e7b";
    bright6    = "a3babf";
    bright7    = "ffffff";

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


