{ config, pkgs, lib, ... }:

{
  # TODO
  # think it will be better to start it from scratch rather than
  # base it on colemak_dh_iso because the latter actually has quite a few issues
  # (namely, many empty lvl3 and lvl4 keys which is a waste), and i also need to flip ; and :
  services.xserver.xkb.extraLayouts = {
    colemak-dh-iso-fix-z = {
      description = "Colemak-DH ISO but we swap z and lsgt";
      languages = [ "eng" ];
      symbolsFile = builtins.toFile "xkbconf_colemak-dh-iso-fix-z"
        ''
        xkb_symbols "colemak_dh_iso_fixed_z" {

            name[Group1]= "English (Colemak-DH ISO (fixed Z))";

            // …

            include "level3(ralt_switch)"
        };

        ''
        ;
    };
  };
}


