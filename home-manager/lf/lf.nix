{ ... }:

{
  programs.lf = {
    enable = true;
    extraConfig = builtins.readFile ./lfrc;
    # previewer.source = ./<TODO>;
    # or
    # ...
    # maybe just switch to broot
  };

  xdg.configFile = {
    "lf/icons".source = ./icons;
    "lf/colors".source = ./colors;
  };
}
