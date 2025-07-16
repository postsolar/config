{ ... }:

{
  services.xserver.xkb.extraLayouts = {
    carpalx-qwyrfm = {
      description = "Carpalx partial layout (10 key swaps, QWYRFM)";
      languages = [ "eng" ];
      symbolsFile = builtins.toFile "xkbconf-carpalx-qwyrfm"
        ''
        xkb_symbols "carpalx-qwyrfm" {
          include "us(altgr-intl)"
          name[Group1] = "Carpalx partial layout (10 key swaps, QWYRFM)";

          key <AD03> { [     y,          Y,    udiaeresis,       Udiaeresis ] };
          key <AD05> { [     f,          F,    ediaeresis,       Ediaeresis ] };
          key <AD06> { [     m,          M,            mu,        plusminus ] };
          key <AD07> { [     l,          L,        oslash,           Oslash ] };
          key <AD08> { [     u,          U,        uacute,           Uacute ] };
          key <AD09> { [     b,          B,             b,                B ] };

          key <AC01> { [     d,          D,           eth,              ETH ] };
          key <AC03> { [     a,          A,        aacute,           Aacute ] };
          key <AC04> { [     t,          T,         thorn,            THORN ] };
          key <AC05> { [     n,          N,        ntilde,           Ntilde ] };
          key <AC07> { [     o,          O,        oacute,           Oacute ] };
          key <AC08> { [     e,          E,        eacute,           Eacute ] };
          key <AC09> { [     i,          I,        iacute,           Iacute ] };
          // also flip ; and :
          key <AC10> { [ colon,      semicolon,     paragraph,           degree ] };
          // fix quotes (based on colemak)
          key <AC11> { [ apostrophe, quotedbl,     otilde,           Otilde ] };

          key <AB05> { [     j,          J,    idiaeresis,       Idiaeresis ] };
          key <AB06> { [     g,          G,             g,                G ] };
          key <AB07> { [     k,          K,            oe,               OE ] };

          include "level3(ralt_switch)"
        };
        '';
    };
  };
}

