{ inputs, system, ... }:

{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    extensions =
      builtins.attrValues {
        inherit (inputs.vicinae-extensions.packages.${system})
          bluetooth
          brotab # also requires cli tool + extension in respective browser(s)
          case-converter
          fuzzy-files # depends on https://github.com/sameoldlab/goldfish
          nix
          ;
      };
  };
}
