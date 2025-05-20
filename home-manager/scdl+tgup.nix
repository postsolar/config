{ pkgs, ... }:

let
  # TODO: idk rip messes up filenames (adds `01.` even tho there's no playlist)
  # also sometimes dls `cover.jpg`
  # mayb find sth else (scdl isn't flawless either though). but for now this works

  scdl-tgup = pkgs.writers.writeFishBin "scdl-tgup"
    ''
    set -q TG_CHAT && set chat $TG_CHAT || set chat 2437712025
    set links $argv
    set tmp (mktemp --tmpdir --directory scdl-tgup.XXXX)

    rip -f $tmp url $links

    set tdlArgs
    for f in $tmp/*
      set tdlArgs $tdlArgs -p $f
    end

    tdl up -c $chat $tdlArgs
    '';
in

{
  home.packages = [ scdl-tgup pkgs.streamrip pkgs.tdl ];
}
