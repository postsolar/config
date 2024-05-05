##### list of most foot's keys' escape sequences

# those which start with '^[[27;' (IIRC it's libtickit spec)
# are supported on foot only, e.g. on kitty `c-!` is
# equivalent to `!` and `c-a-!` is equivalent to `a-!`.
# this *usually* means the key is only available on foot,
# but not always: e.g. `a-s-tab` would show up as `^[[27;4;9~` in
# foot but as simple '^[^[[Z' in kitty. it is however true that foot
# has by far the most extensive coverage

# ~~some keys are customized and are only relevant with specific settings
# in place. those sections are prefixed with a WARN note~~
# UPDATE: these were commented out because they mess with handling of
# kitty keyboard protocol and given that the reason to enable these
# was the programs that don't implement this protocol in the first place,
# it seems like they're not worth having

# the order of modifiers is strictly hierarchical (c → a → s → key):
#   a-tab, c-a-tab, c-a-s-tab are valid
#   c-s-a-tab, s-a-tab are not valid

# symbols' names mostly come from `xkbcli interactive-wayland`

# if something is left out it's most likely because it doesn't work
# C-S-{a..z} never work
# keypad key are not distinguishable from 'regular' keys
# play/pause, stop, previous, next don't work

#   all keys are preserved regardless of whether there are other keys with
# same mappings. hence, the table is always unsafe to use

{ lib, ... }:

let
  digits = map toString (lib.range 0 9);
  a-alphanums =
    map (k: { name = "a-${k}"; value = "^[${k}"; })
      (digits ++ lib.strings.lowerChars)
    ;
  a-s-alpha =
    map (k: { name = "a-s-${k}"; value = "^[${lib.strings.toUpper k}"; })
      lib.strings.lowerChars
    ;
  c-alpha =
    lib.lists.zipListsWith
      (kl: ku: { name = "c-${kl}"; value = "^${ku}"; })
      lib.strings.lowerChars
      lib.strings.upperChars
    ;
  c-a-alpha =
    lib.lists.zipListsWith
      (kl: ku: { name = "c-a-${kl}"; value = "^[^${ku}"; })
      lib.strings.lowerChars
      lib.strings.upperChars
    ;
in

  lib.listToAttrs (a-alphanums ++ a-s-alpha ++ c-alpha ++ c-a-alpha)
  //

  {

    # default sequences for c-(a-){1..0}
    c-1              = ''^[[27;5;49~'';
    c-2              = ''^@'';
    c-3              = ''^['';
    c-4              = ''^\'';
    c-5              = ''^]'';
    c-6              = ''^^'';
    c-7              = ''^_'';
    c-8              = ''^?'';
    c-9              = ''^[[27;5;57~'';
    c-0              = ''^[[27;5;48~'';
    c-a-1            = ''^[[27;7;49~'';
    c-a-2            = ''^[^@'';
    c-a-3            = ''^[^['';
    c-a-4            = ''^[^\'';
    c-a-5            = ''^[^]'';
    c-a-6            = ''^[^^'';
    c-a-7            = ''^[^_'';
    c-a-8            = ''^[^?'';
    c-a-9            = ''^[[27;7;57~'';
    c-a-0            = ''^[;[27;7;48~'';

    #  WARN custom ones, defined in settings
    # c-1   = ''^[[27;5;49~'';
    # c-2   = ''^[[27;5;50~'';
    # c-3   = ''^[[27;5;51~'';
    # c-4   = ''^[[27;5;52~'';
    # c-5   = ''^[[27;5;53~'';
    # c-6   = ''^[[27;5;54~'';
    # c-7   = ''^[[27;5;55~'';
    # c-8   = ''^[[27;5;56~'';
    # c-9   = ''^[[27;5;57~'';
    # c-0   = ''^[[27;5;58~'';
    # c-a-1 = ''^[[27;7;49~'';
    # c-a-2 = ''^[[27;7;50~'';
    # c-a-3 = ''^[[27;7;51~'';
    # c-a-4 = ''^[[27;7;52~'';
    # c-a-5 = ''^[[27;7;53~'';
    # c-a-6 = ''^[[27;7;54~'';
    # c-a-7 = ''^[[27;7;55~'';
    # c-a-8 = ''^[[27;7;56~'';
    # c-a-9 = ''^[[27;7;57~'';
    # c-a-0 = ''^[[27;7;58~'';

    tab              = ''^I'';
    s-tab            = ''^[[Z'';
    a-tab            = ''^[^I'';
    a-s-tab          = ''^[[27;4;9~'';
    c-tab            = ''^[[27;5;9~'';
    c-s-tab          = ''^[[27;6;9~'';
    c-a-tab          = ''^[[27;7;9~'';
    c-a-s-tab        = ''^[[27;8;9~'';

    pageup           = ''^[[5~'';
    pagedown         = ''^[[6~'';
    home             = ''^[[H'';
    end              = ''^[[F'';

    s-home           = ''^[[1;2H'';
    a-home           = ''^[[1;3H'';
    a-s-home         = ''^[[1;4H'';
    c-home           = ''^[[1;5H'';
    c-s-home         = ''^[[1;6H'';
    c-a-home         = ''^[[1;7H'';
    c-a-s-home       = ''^[[1;8H'';

    s-end            = ''^[[1;2F'';
    a-end            = ''^[[1;3F'';
    a-s-end          = ''^[[1;4F'';
    c-end            = ''^[[1;5F'';
    c-s-end          = ''^[[1;6F'';
    c-a-end          = ''^[[1;7F'';
    c-a-s-end        = ''^[[1;8F'';

    s-pageup         = ''^[[5;2~'';
    a-pageup         = ''^[[5;3~'';
    a-s-pageup       = ''^[[5;4~'';
    c-pageup         = ''^[[5;5~'';
    c-s-pageup       = ''^[[5;6~'';
    c-a-pageup       = ''^[[5;7~'';
    c-a-s-pageup     = ''^[[5;8~'';

    s-pagedown       = ''^[[6;2~'';
    a-pagedown       = ''^[[6;3~'';
    a-s-pagedown     = ''^[[6;4~'';
    c-pagedown       = ''^[[6;5~'';
    c-s-pagedown     = ''^[[6;6~'';
    c-a-pagedown     = ''^[[6;7~'';
    c-a-s-pagedown   = ''^[[6;8~'';

    f1               = ''^[OP'';
    f2               = ''^[OQ'';
    f3               = ''^[OR'';
    f4               = ''^[OS'';
    f5               = ''^[[15~'';
    f6               = ''^[[17~'';
    f7               = ''^[[18~'';
    f8               = ''^[[19~'';
    f9               = ''^[[20~'';
    f10              = ''^[[21~'';
    f11              = ''^[[23~'';
    f12              = ''^[[24~'';

    s-f1             = ''^[[1;2P'';
    s-f2             = ''^[[1;2Q'';
    s-f3             = ''^[[1;2R'';
    s-f4             = ''^[[1;2S'';
    s-f5             = ''^[[15;2~'';
    s-f6             = ''^[[17;2~'';
    s-f7             = ''^[[18;2~'';
    s-f8             = ''^[[19;2~'';
    s-f9             = ''^[[20;2~'';
    s-f10            = ''^[[21;2~'';
    s-f11            = ''^[[23;2~'';
    s-f12            = ''^[[24;2~'';

    a-f1             = ''^[[1;3P'';
    a-f2             = ''^[[1;3Q'';
    a-f3             = ''^[[1;3R'';
    a-f4             = ''^[[1;3S'';
    a-f5             = ''^[[15;3~'';
    a-f6             = ''^[[17;3~'';
    a-f7             = ''^[[18;3~'';
    a-f8             = ''^[[19;3~'';
    a-f9             = ''^[[20;3~'';
    a-f10            = ''^[[21;3~'';
    a-f11            = ''^[[23;3~'';
    a-f12            = ''^[[24;3~'';

    a-s-f1           = ''^[[1;4P'';
    a-s-f2           = ''^[[1;4Q'';
    a-s-f3           = ''^[[1;4R'';
    a-s-f4           = ''^[[1;4S'';
    a-s-f5           = ''^[[15;4~'';
    a-s-f6           = ''^[[17;4~'';
    a-s-f7           = ''^[[18;4~'';
    a-s-f8           = ''^[[19;4~'';
    a-s-f9           = ''^[[20;4~'';
    a-s-f10          = ''^[[21;4~'';
    a-s-f11          = ''^[[23;4~'';
    a-s-f12          = ''^[[24;4~'';

    c-f1             = ''^[[1;5P'';
    c-f2             = ''^[[1;5Q'';
    c-f3             = ''^[[1;5R'';
    c-f4             = ''^[[1;5S'';
    c-f5             = ''^[[15;5~'';
    c-f6             = ''^[[17;5~'';
    c-f7             = ''^[[18;5~'';
    c-f8             = ''^[[19;5~'';
    c-f9             = ''^[[20;5~'';
    c-f10            = ''^[[21;5~'';
    c-f11            = ''^[[23;5~'';
    c-f12            = ''^[[24;5~'';

    c-s-f1           = ''^[[1;6P'';
    c-s-f2           = ''^[[1;6Q'';
    c-s-f3           = ''^[[1;6R'';
    c-s-f4           = ''^[[1;6S'';
    c-s-f5           = ''^[[15;6~'';
    c-s-f6           = ''^[[17;6~'';
    c-s-f7           = ''^[[18;6~'';
    c-s-f8           = ''^[[19;6~'';
    c-s-f9           = ''^[[20;6~'';
    c-s-f10          = ''^[[21;6~'';
    c-s-f11          = ''^[[23;6~'';
    c-s-f12          = ''^[[24;6~'';

    # c-a-fN         doesn't get registered and would switch me to another TTY anyways

    c-a-s-f1         = ''^[[1;8P'';
    c-a-s-f2         = ''^[[1;8Q'';
    c-a-s-f3         = ''^[[1;8R'';
    c-a-s-f4         = ''^[[1;8S'';
    c-a-s-f5         = ''^[[15;8~'';
    c-a-s-f6         = ''^[[17;8~'';
    c-a-s-f7         = ''^[[18;8~'';
    c-a-s-f8         = ''^[[19;8~'';
    c-a-s-f9         = ''^[[20;8~'';
    c-a-s-f10        = ''^[[21;8~'';
    c-a-s-f11        = ''^[[23;8~'';
    c-a-s-f12        = ''^[[24;8~'';

    insert           = ''^[[2~'';
    s-insert         = ''^[[2;2~'';
    a-insert         = ''^[[2;3~'';
    a-s-insert       = ''^[[2;4~'';
    c-insert         = ''^[[2;5~'';
    c-s-insert       = ''^[[2;6~'';
    c-a-insert       = ''^[[2;7~'';
    c-a-s-insert     = ''^[[2;8~'';

    delete           = ''^[[3~'';
    s-delete         = ''^[[3;2~'';
    a-delete         = ''^[[3;3~'';
    a-s-delete       = ''^[[3;4~'';
    c-delete         = ''^[[3;5~'';
    c-s-delete       = ''^[[3;6~'';
    c-a-delete       = ''^[[3;7~'';
    c-a-s-delete     = ''^[[3;8~'';

    backspace        = ''^?'';
    a-backspace      = ''^[^?'';
    c-backspace      = ''^H'';
    c-a-backspace    = ''^[^H'';
    #  WARN extra custom backspace keys — configured in settings
    # s-backspace      = ''^[[27;2;12~'';
    # a-s-backspace    = ''^[[27;4;12~'';
    # c-s-backspace    = ''^[[27;6;12~'';
    # c-a-s-backspace  = ''^[[27;8;12~'';

    enter            = ''^M'';
    s-enter          = ''^[[27;2;13~'';
    a-enter          = ''^[^M'';
    a-s-enter        = ''^[[27;4;13~'';
    c-enter          = ''^[[27;5;13~'';
    c-s-enter        = ''^[[27;6;13~'';
    c-a-enter        = ''^[[27;7;13~'';
    c-a-s-enter      = ''^[[27;8;13~'';

    space            = '' '';
    a-space          = ''^[ '';
    c-space          = ''^@'';
    c-a-space        = ''^[^@'';
    #  WARN extra custom space keys — configured in settings
    # s-space          = ''^[[27;2;14~'';
    # a-s-space        = ''^[[27;4;14~'';
    # c-s-space        = ''^[[27;6;14~'';
    # c-a-s-space      = ''^[[27;8;14~'';

    up               = ''^[[A'';
    s-up             = ''^[[1;2A'';
    a-up             = ''^[[1;3A'';
    a-s-up           = ''^[[1;4A'';
    c-up             = ''^[[1;5A'';
    c-s-up           = ''^[[1;6A'';
    c-a-up           = ''^[[1;7A'';
    c-a-s-up         = ''^[[1;8A'';
    down             = ''^[[B'';
    s-down           = ''^[[1;2B'';
    a-down           = ''^[[1;3B'';
    a-s-down         = ''^[[1;4B'';
    c-down           = ''^[[1;5B'';
    c-s-down         = ''^[[1;6B'';
    c-a-down         = ''^[[1;7B'';
    c-a-s-down       = ''^[[1;8B'';
    right            = ''^[[C'';
    s-right          = ''^[[1;2C'';
    a-right          = ''^[[1;3C'';
    a-s-right        = ''^[[1;4C'';
    c-right          = ''^[[1;5C'';
    c-s-right        = ''^[[1;6C'';
    c-a-right        = ''^[[1;7C'';
    c-a-s-right      = ''^[[1;8C'';
    left             = ''^[[D'';
    s-left           = ''^[[1;2D'';
    a-left           = ''^[[1;3D'';
    a-s-left         = ''^[[1;4D'';
    c-left           = ''^[[1;5D'';
    c-s-left         = ''^[[1;6D'';
    c-a-left         = ''^[[1;7D'';
    c-a-s-left       = ''^[[1;8D'';

    a-grave          = ''^[`'';
    #  WARN customized sequences
    # c-grave          = ''^`'';
    # c-a-grave        = ''^[^`'';
    # default sequences
    c-grave          = ''^@'';
    c-a-grave        = ''^[^@'';

    a-tilde          = ''^[~'';
    #  WARN customized sequences
    # c-tilde          = ''^~'';
    # c-a-tilde        = ''^[^~'';
    # default sequences
    c-tilde          = ''^^'';
    c-a-tilde        = ''^[^^'';

    a-exclam         = ''^[!'';
    c-exclam         = ''^[[27;6;33~'';
    c-a-exclam       = ''^[[27;8;33~'';

    a-at             = ''^[@'';
    c-at             = ''^@'';
    c-a-at           = ''^[^@'';

    a-numbersign     = ''^[#'';
    c-numbersign     = ''^[[27;6;35~'';
    c-a-numbersign   = ''^[[27;8;35~'';

    a-dollar         = ''^[$'';
    c-dollar         = ''^[[27;6;36~'';
    c-a-dollar       = ''^[[27;8;36~'';

    a-percent        = ''^[%'';
    c-percent        = ''^[[27;6;37~'';
    c-a-percent      = ''^[[27;8;37~'';

    a-circum         = ''^[^'';
    c-circum         = ''^^'';
    c-a-circum       = ''^[^^'';

    a-ampersand      = ''^[&'';
    c-ampersand      = ''^[[27;6;38~'';
    c-a-ampersand    = ''^[[27;8;38~'';

    a-asterisk       = ''^[*'';
    c-asterisk       = ''^[[27;6;42~'';
    c-a-asterisk     = ''^[[27;8;42~'';

    a-parenleft      = ''^[('';
    c-parenleft      = ''^[[27;6;40~'';
    c-a-parenleft    = ''^[[27;8;40~'';

    a-parenright     = ''^[)'';
    c-parenright     = ''^[[27;6;41~'';
    c-a-parenright   = ''^[[27;8;41~'';

    a-minus          = ''^[-'';
    c-a-minus        = ''^[[27;7;45~'';

    a-underscore     = ''^[_'';
    c-underscore     = ''^_'';
    c-a-underscore   = ''^[^_'';

    a-equals         = ''^[='';
    c-a-equals       = ''^[[27;7;61~'';

    a-plus           = ''^[+'';
    c-a-plus         = ''^[[27;8;43~'';

    a-bracketleft    = ''^[['';
    c-bracketleft    = ''^['';
    c-a-bracketleft  = ''^[^['';
    a-bracketright   = ''^[]'';
    c-bracketright   = ''^]'';
    c-a-bracketright = ''^[^]'';
    a-braceleft      = ''^[{'';
    a-braceright     = ''^[}'';

    a-apostrophe     = "^['";
    c-apostrophe     = ''^[[27;5;39~'';
    c-a-apostrophe   = ''^[[27;7;39~'';

    a-quote          = ''^["'';
    c-quote          = ''^[[27;6;34~'';
    c-a-quote        = ''^[[27;8;34~'';

    a-backslash      = ''^[\'';
    c-backslash      = ''^\'';
    c-a-backslash    = ''^[^\'';

    a-bar            = ''^[|'';
    c-bar            = ''^\'';
    c-a-bar          = ''^[^\'';

    a-less           = ''^[<'';
    c-less           = ''^[[27;5;60~'';
    c-a-less         = ''^[[27;7;60~'';

    a-greater        = ''^[>'';
    c-greater        = ''^[[27;6;62~'';
    c-a-greater      = ''^[[27;8;62~'';

    a-comma          = ''^[,'';
    c-comma          = ''^[[27;5;44~'';
    c-a-comma        = ''^[[27;7;44~'';

    a-dot            = ''^[.'';
    c-dot            = ''^[[27;5;46~'';
    c-a-dot          = ''^[[27;7;46~'';

    a-slash          = ''^[/'';
    c-slash          = ''^_'';
    c-a-slash        = ''^[^_'';

    a-question       = ''^[?'';
    c-question       = ''^[[27;6;63~'';
    c-a-question     = ''^[[27;8;63~'';

    escape           = ''^['';
    s-escape         = ''^[[27;2;27~'';
    a-escape         = ''^[^['';
    a-s-escape       = ''^[[27;4;27~'';
    c-escape         = ''^[[27;5;27~'';
    c-s-escape       = ''^[[27;6;27~'';
    c-a-escape       = ''^[[27;7;27~'';
    c-a-s-escape     = ''^[[27;8;27~'';

  }

