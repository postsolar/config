{ lib, pkgs, config, ... }:

let

  cfg = config.theme;

  inherit (lib) types;

  colorType = types.strMatching "#[[:xdigit:]]{6}";

in

{
  options.theme = {

    exportJSON = {
      enable = lib.mkEnableOption "Exporting theme values as JSON";
      paths = lib.mkOption {
        type = types.listOf types.str;
        description = "Paths (relative to home) to export JSON theme values to";
      };
    };


    fonts = {
      monospace = lib.mkOption {
        type = types.nonEmptyListOf types.str;
        description = "Name of the default monospace theme";
      };
      sansSerif = lib.mkOption {
        type = types.nonEmptyListOf types.str;
        description = "Name of the default sans-serif font";
      };
      serif = lib.mkOption {
        type = types.nonEmptyListOf types.str;
        description = "Name of the default serif font";
      };
      emoji = lib.mkOption {
        type = types.nonEmptyListOf types.str;
        description = "Name of the default emoji font";
      };
    };

    colors = lib.mkOption {
      type = types.attrsOf colorType;
      description = "Any colors";
    };

  };

  config = {
    home.file =
      let
        inherit (cfg.exportJSON) enable paths;
      in
        lib.mkIf enable (lib.genAttrs paths (path: {
          source = pkgs.writers.writeJSON path { inherit (cfg) fonts colors; };
        }));
  };

}

