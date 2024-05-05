args@{ pkgs, config, ... }:

let

  inherit (import ./util.nix args)
    mkFishPlugin
    sessionVariablesSetup
    ;

in

{

  xdg.configFile = {

    "fish/home-manager-vars.fish".source = sessionVariablesSetup;

    "fish/interactive/atuin.fish".source =
      pkgs.runCommandLocal "fish atuin init" {}
        ''
        XDG_CONFIG_HOME=/tmp/ XDG_DATA_HOME=/tmp/ \
          ${config.programs.atuin.package}/bin/atuin init fish \
            --disable-up-arrow \
            --disable-ctrl-r \
              > $out
        ''
      ;

    "fish/conf.d/plugin-done.fish".text = mkFishPlugin
      { name = "done"; src = pkgs.fishPlugins.done.src; };

  };

}

