{ lib, pkgs, config, ... }:

let

  # zcompile files based on a glob expression
  zcompileGlob = globs: /* sh */ ''
    ${config.programs.zsh.package}/bin/zsh -dfc '
      setopt extendedglob globstarshort dotglob
      for f in ${globs}; do
        zcompile -U -- $f 2>/dev/null
      done
    ' || :
  '';

  # make a derivation out of a plugin's name and source.
  # will zcompile it automatically. optionally, the unpack
  # phase can be overwritten.
  mkZshPlugin = name: attrs:
    pkgs.callPackage
      ({ stdenvNoCC }: stdenvNoCC.mkDerivation (attrs // {
          inherit name;
          phases = [ "unpackPhase" ];
          unpackPhase =
            (attrs.unpackPhase or /* sh */ ''
              mkdir -p -- $out/
              cp -r $src/.* $src/* $out/
              ''
            ) + ''
              ${ zcompileGlob "$out/**" }
            ''
            ;
      }))
      {};

  zsh-syntax-highlighting =
    let name = "zsh-syntax-highlighting"; in mkZshPlugin name {
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo  = name;
        rev   = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
        hash  = "sha256-4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
      };
    };

  zsh-history-substring-search =
    let name = "zsh-history-substring-search"; in mkZshPlugin name {
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo  = name;
        rev   = "8dd05bfcc12b0cd1ee9ea64be725b3d9f713cf64";
        hash  = "sha256-houujb1CrRTjhCc+dp3PRHALvres1YylgxXwjjK6VZA=";
      };
    };

  zsh-autosuggestions =
    let name = "zsh-autosuggestions"; in mkZshPlugin name {
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo  = name;
        rev   = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
        hash  = "sha256-B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
      };
      unpackPhase = ''
        mkdir -p $out/
        sed 's/(( $#POSTDISPLAY ))/(( ''${#''${POSTDISPLAY-}} ))/' \
          < $src/${name}.zsh > $out/${name}.zsh
      '';
    };

  fzf-tab-completion =
    let name = "fzf-tab-completion"; in mkZshPlugin name {
      src = pkgs.fetchFromGitHub {
        owner = "lincheney";
        repo  = name;
        rev   = "6a0799eb867b06762fb8f07dbd9899eb7d0969b5";
        hash  = "sha256-bDqbNxEswhCrzmIiMomJTfEhwE2FaFjkflhxpsKTaD8=";
      };
      unpackPhase = ''
        mkdir -p $out/
        cp $src/zsh/fzf-zsh-completion.sh $out/${name}.zsh
      '';
    };

  zsh-smartcache =
    let name = "zsh-smartcache"; in mkZshPlugin name {
      src = pkgs.fetchFromGitHub {
        owner = "QuarticCat";
        repo = "zsh-smartcache";
        rev = "b78da10ad02fb7cf51636eb2043a9f7c8573138d";
        hash = "sha256-X6qoZh9j81uaUYS//6FPo4vhAkkqKJM/qcZWAVCfHgo=";
      };
    };

  zsh-no-ps2 =
    let name = "zsh-no-ps2"; in mkZshPlugin name {
      src = pkgs.fetchFromGitHub {
        owner = "romkatv";
        repo = "zsh-no-ps2";
        rev = "4b23567dc503170672386660706e55ce0201770c";
        hash = "sha256-blu8KEdF4IYEI3VgIkSYsd0RZsAHErj9KnC67MN5Jsw=";
      };
    };

  atuin-integration = pkgs.runCommandLocal "zsh atuin init" {}
    ''
    sd=${pkgs.sd}/bin/sd

    XDG_CONFIG_HOME=/tmp/ XDG_DATA_HOME=/tmp/ \
      ${config.programs.atuin.package}/bin/atuin init zsh \
        | $sd '^bindkey.+?\n' "" \
        | $sd -f s '_zsh_autosuggest_strategy_atuin\(\) \{.+?\}' \
            '_zsh_autosuggest_strategy_atuin () {
              suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix --cwd $$PWD -- "$$1")
            }
            ' > $out
    '';

in

{

  xdg.configFile = {

    # entrypoint
    # zdotdir is set by the nixos module and points to $XDG_CONFIG_HOME/zsh

    "zsh/.zshenv".source = ./zshenv;

    # plugins

    "zsh/plugins/zsh-syntax-highlighting".source      = zsh-syntax-highlighting;
    "zsh/plugins/zsh-history-substring-search".source = zsh-history-substring-search;
    "zsh/plugins/zsh-autosuggestions".source          = zsh-autosuggestions;
    "zsh/plugins/fzf-tab-completion".source           = fzf-tab-completion;
    "zsh/plugins/atuin.zsh".source                    = atuin-integration;
    "zsh/plugins/zsh-smartcache".source               = zsh-smartcache;
    "zsh/plugins/zsh-no-ps2".source                   = zsh-no-ps2;

    # run control

    "zsh/environment" = {
      source = ./environment;
      recursive = true;
      onChange = zcompileGlob "environment/**.zsh";
    };

    "zsh/interactive" = {
      source = ./interactive;
      recursive = true;
      onChange = zcompileGlob "interactive/**.zsh";
    };

    "zsh/keybindings/keybindings.zsh" = {
      source = ./keybindings/keybindings.zsh;
      onChange = zcompileGlob "keybindings/keybindings.zsh";
    };

    "zsh/keybindings/keymap_foot.zsh" = {
      text =
        import ./keybindings/keymap_foot.nix
          { footKeysAttrSet = import ../foot/keys.nix { inherit lib; };
            inherit lib;
          };
      onChange = zcompileGlob "keybindings/keymap_foot.zsh";
    };

    "zsh/widgets" = {
      source = ./widgets;
      recursive = true;
      onChange = zcompileGlob "widgets/**.zsh";
    };
  };

}

