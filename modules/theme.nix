{ config, lib, ... }:

let

  stripNumberSign = builtins.replaceStrings [ "#" ] [ "" ];

  cfg = config.theme;

in

{

  options.theme = with lib; {

    export = mkEnableOption "exporting theme values in JSON, SASS and other formats in `${config.xdg.configHome}/theme/` directory";

    colors = mkOption {
      type = types.attrsOf (types.strMatching "#[A-Fa-f0-9]{6}");
      default = {};
      example = literalExpression
        ''
        {
          color0 = "#123123";
          color1 = "#231231";
          background = "#000000";
        }
        '';
      description =
        ''
        Attribute set which defines named hex colors, prefixed with `#`.
        '';
    };

    colorsNoPrefix = mkOption {
      type = types.attrsOf (types.strMatching "[A-Fa-f0-9]{6}");
      readOnly = true;
      default = lib.attrsets.mapAttrs (_: stripNumberSign) config.theme.colors;
      description =
        ''
        This read-only option tracks the option `colors`, but with leading `#` removed.
        Useful for configuration of many programs.
        '';
    };

    alpha = mkOption {
      type = types.nullOr (types.numbers.between 0 1);
      default = null;
      example = literalExpression "1.0";
      description =
        ''
        Default alpha value.
        '';
    };

    monospaceFont = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = literalExpression ''"SF Mono"'';
      description =
        ''
        Default monospace font.
        '';
    };

    variableWidthFont = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = literalExpression ''"SF Pro"'';
      description =
        ''
        Default variable width font.
        '';
    };

  };

  config = {

    xdg.configFile = {
      "theme/theme.json".text =
        lib.mkIf cfg.export (builtins.toJSON {
          inherit (cfg)
            colors
            colorsNoPrefix
            monospaceFont
            variableWidthFont
            ;
        });
    };

  };

}

