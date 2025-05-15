{ config, pkgs, lib, ... }:

{
  services.xserver.xkb.extraLayouts = {
    carpalx-qwyrfm = {
      description = "Carpalx partial layout (10 key swaps, QWYRFM)";
      languages = [ "eng" ];
      symbolsFile = builtins.toFile "xkbconf-carpalx-qwyrfm"
        ''
        xkb_symbols "carpalx-qwyrfm" {
          include "us(intl)"
          name[Group1] = "Carpalx partial layout (10 key swaps, QWYRFM)";

          // fix tilde (based on colemak)
          key <TLDE> { [ grave, asciitilde,  dead_tilde,       asciitilde ] };

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

    colemak-dh-iso-fix-z = {
      description = "Colemak-DH ISO but we swap z and lsgt";
      languages = [ "eng" ];
      symbolsFile = builtins.toFile "xkbconf_colemak-dh-iso-fix-z"
        ''
        xkb_symbols "colemak_dh_iso_fixed_z" {

          name[Group1]= "English (Colemak-DH ISO (fixed Z))";

          key <TLDE> { [        grave,   asciitilde,      dead_tilde,       asciitilde ] };
          key <AE01> { [            1,       exclam,      exclamdown,      onesuperior ] };
          key <AE02> { [            2,           at,       masculine,      twosuperior ] };
          key <AE03> { [            3,   numbersign,     ordfeminine,    threesuperior ] };
          key <AE04> { [            4,       dollar,            cent,         sterling ] };
          key <AE05> { [            5,      percent,        EuroSign,              yen ] };
          key <AE06> { [            6,  asciicircum,         hstroke,          Hstroke ] };
          key <AE07> { [            7,    ampersand,             eth,              ETH ] };
          key <AE08> { [            8,     asterisk,           thorn,            THORN ] };
          key <AE09> { [            9,    parenleft,  leftsinglequotemark,  leftdoublequotemark ] };
          key <AE10> { [            0,   parenright, rightsinglequotemark,  rightdoublequotemark ] };
          key <AE11> { [        minus,   underscore,          endash,           emdash ] };
          key <AE12> { [        equal,         plus,        multiply,         division ] };

          key <AD01> { [            q,            Q,      adiaeresis,       Adiaeresis ] };
          key <AD02> { [            w,            W,           aring,            Aring ] };
          key <AD03> { [            f,            F,          atilde,           Atilde ] };
          key <AD04> { [            p,            P,          oslash,           Oslash ] };
          key <AD05> { [            b,            B,     dead_breeve,       asciitilde ] };
          key <AD06> { [            j,            J,         dstroke,          Dstroke ] };
          key <AD07> { [            l,            L,         lstroke,          Lstroke ] };
          key <AD08> { [            u,            U,          uacute,           Uacute ] };
          key <AD09> { [            y,            Y,      udiaeresis,       Udiaeresis ] };
          key <AD10> { [        colon,    semicolon,      odiaeresis,       Odiaeresis ] };
          key <AD11> { [  bracketleft,    braceleft,   guillemotleft,        0x1002039 ] };
          key <AD12> { [ bracketright,   braceright,  guillemotright,        0x100203a ] };

          key <AC01> { [            a,            A,          aacute,           Aacute ] };
          key <AC02> { [            r,            R,      dead_grave,       asciitilde ] };
          key <AC03> { [            s,            S,          ssharp,        0x1001e9e ] };
          key <AC04> { [            t,            T,      dead_acute, dead_doubleacute ] };
          key <AC05> { [            g,            G,  dead_diaeresis,       asciitilde ] };
          key <AC06> { [            m,            M,      dead_caron,       asciitilde ] };
          key <AC07> { [            n,            N,          ntilde,           Ntilde ] };
          key <AC08> { [            e,            E,          eacute,           Eacute ] };
          key <AC09> { [            i,            I,          iacute,           Iacute ] };
          key <AC10> { [            o,            O,          oacute,           Oacute ] };
          key <AC11> { [   apostrophe,     quotedbl,          otilde,           Otilde ] };
          key <BKSL> { [    backslash,          bar,      asciitilde,       asciitilde ] };

          key <AB01> { [            x,            X, dead_circumflex,       asciitilde ] };
          key <AB02> { [            c,            C,        ccedilla,         Ccedilla ] };
          key <AB03> { [            d,            D,  dead_diaeresis,       asciitilde ] };
          key <AB04> { [            v,            V,              oe,               OE ] };
          key <AB05> { [            z,            Z,              ae,               AE ] };
          key <AB06> { [            k,            K,  dead_abovering,       asciitilde ] };
          key <AB07> { [            h,            H,     dead_macron,       asciitilde ] };
          key <AB08> { [        comma,         less,    dead_cedilla,       asciitilde ] };
          key <AB09> { [       period,      greater,   dead_abovedot,       asciitilde ] };
          key <AB10> { [        slash,     question,    questiondown,       asciitilde ] };

          include "level3(ralt_switch)"
        };
        ''
        ;
    };
  };
}

