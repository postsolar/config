{ config, pkgs, ... }:

let

  # recent versions of fish support `export X=1` syntax
  # but there are still some tricky expansions used
  sessionVariablesSetup =
    pkgs.runCommandLocal "hm-session-vars.fish" {} ''
      cat ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh \
        | sed -r 's/^.+?_HM_SESS_VARS_SOURCED.+?$//' \
        | sed -r 's/^# Only source this once.//' \
        | ${pkgs.buildPackages.babelfish}/bin/babelfish \
      > $out
    '';

  # taken from https://github.com/nix-community/home-manager/blob/206f457fffdb9a73596a4cb2211a471bd305243d/modules/programs/fish.nix#L518
  mkFishPlugin = plugin: /* fish */
    ''
    # Plugin ${plugin.name}
    set -l plugin_dir ${plugin.src}

    # Set paths to import plugin components
    if test -d $plugin_dir/functions
      set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
    end

    if test -d $plugin_dir/completions
      set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
    end

    # Source initialization code if it exists.
    if test -d $plugin_dir/conf.d
      for f in $plugin_dir/conf.d/*.fish
        source $f
      end
    end

    if test -f $plugin_dir/key_bindings.fish
      source $plugin_dir/key_bindings.fish
    end

    if test -f $plugin_dir/init.fish
      source $plugin_dir/init.fish
    end
    '';

in
  {
    inherit
      mkFishPlugin
      sessionVariablesSetup
      ;
  }

