{ config, lib, pkgs, flakeDir, ... }:

let

  link = f: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home-manager/fish/${f}";

  # shave 3ms off startup time by not calling the bin each time
  starshipInit = pkgs.runCommandLocal "fish starship init" {}
    ''
    ${lib.getExe config.programs.starship.package} init fish --print-full-init >$out 2>/dev/null
    '';

in

{

  imports = [
    ./keybindings.nix
  ];

  programs.fish = {
    enable = true;

    loginShellInit = # fish
      ''
      status is-interactive; and cd /data
      '';

    shellInit = # fish
      ''
      # TODO maybe shouldn't be fish-related actually
      source ${../../secrets/api_keys.env}
      '';

    interactiveShellInit = # fish
      ''
      source ${starshipInit}
      source ${link "./functions.fish"}
      '';
  };

}

