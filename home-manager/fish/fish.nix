{ config, lib, pkgs, ... }:

let

  # shave 5ms off startup time by not calling the bin each time
  atuinInit = pkgs.runCommandLocal "fish atuin init" {}
    ''
    tmp=$(mktemp -d)
    export XDG_CONFIG_HOME=$tmp XDG_DATA_HOME=$tmp
    ${lib.getExe config.programs.atuin.package} init fish --disable-up-arrow --disable-ctrl-r >$out
    '';

  # shave 3ms off startup time by not calling the bin each time
  starshipInit = pkgs.runCommandLocal "fish starship init" {}
    ''
    ${lib.getExe config.programs.starship.package} init fish --print-full-init >$out 2>/dev/null
    '';

  # shave 10ms off startup time by not calling the bin each time
  carapaceInit = pkgs.runCommandLocal "fish carapace init" {}
    ''
    ${lib.getExe config.programs.carapace.package} _carapace fish >$out
    '';

in

{

  imports = [
    ./keybindings.nix
  ];

  home.packages = [
    pkgs.carapace
  ];

  programs.fish = {
    enable = true;

    shellInit = # fish
      ''
      source ${../../secrets/api_keys.env}
      '';

    interactiveShellInit = # fish
      ''
      source ${starshipInit}
      source ${atuinInit}
      # carapace seems to break too much; more than it adds
      # set -x CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
      # source ${carapaceInit}

      source ${./functions.fish}
      '';
  };

}

