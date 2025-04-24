{ ... }:

{
  programs.lf = {
    enable = true;
    extraConfig = builtins.readFile ./lfrc;
    # previewer.source = ./previewer;
  };

  xdg.configFile = {
    "lf/icons".source = ./icons;
    "lf/colors".source = ./colors;
  };
}
