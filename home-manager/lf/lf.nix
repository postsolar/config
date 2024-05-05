{ config, lib, pkgs, ... }:

let
  previewer =
    let name = "lf-previewer"; in
      pkgs.writeZshApplication {
        inherit name;
        runtimeInputs = [ pkgs.file pkgs.chafa ];
        text = builtins.readFile ./preview.zsh;
      };
in
{
  programs.lf = {
    enable = true;
    package = pkgs.lf;
    extraConfig = builtins.readFile ./lfrc;
    previewer.source = lib.getExe previewer;
  };

  xdg.configFile."lf/icons".source  = config.lib.file.mkOutOfStoreSymlink ./icons;
  xdg.configFile."lf/colors".source = config.lib.file.mkOutOfStoreSymlink ./colors;
}

