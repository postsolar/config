{ inputs, config, pkgs, lib, system, ... }:

let

  kakoune = pkgs.kakoune-unwrapped.overrideAttrs {
    src = inputs.kakoune;
    patches = [];
  };

  kak-tabs =
    pkgs.kakouneUtils.buildKakounePluginFrom2Nix rec {
      pname = "kak-tabs";
      version = "0.1.7";

      src = pkgs.rustPlatform.buildRustPackage {
        name = pname;
        src = inputs.kak-tabs;
        cargoLock = { lockFile = "${inputs.kak-tabs}/Cargo.lock"; };

        # 1) set the path for kak-tabs
        # 2) remove debug buffer from the buflist passed to kak-tabs
        postInstall = ''
          substitute "$src/rc/tabs.kak" "$out/tabs.kak" \
            --replace 'eval "kak-tabs' 'eval "'$out'/bin/kak-tabs'
          '';
      };
    };

in

  {

    programs.kakoune = {
      enable = true;
      package = kakoune;
      extraConfig = builtins.readFile ./kakrc;

      plugins = [
        inputs.kak-ansi.packages.${system}.kak-ansi
        kak-tabs
        pkgs.kakounePlugins.byline-kak
      ];
    };

    xdg.configFile = {

      "kak/keybindings" = {
        source = ./keybindings;
        recursive = true;
      };

      "kak/colors/default.kak".text =
        import ./colors/default.nix {
          colors = config.theme.colorsNoPrefix;
          inherit lib;
        };

    };

  }

