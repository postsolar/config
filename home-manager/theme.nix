{ ... }:

{
  imports = [ ../modules/theme.nix ];

  theme.export = true;

  theme.monospaceFont = "Ellograph CF";
  theme.variableWidthFont = "SF Pro";

  theme.colors = {
    color0       = "#3a324e";
    color1       = "#ff6b7f";
    color2       = "#00bd9c";
    color3       = "#e6c62f";
    color4       = "#22e8df";
    color5       = "#dc396a";
    color6       = "#56b6c2";
    color7       = "#f1f1f1";
    color8       = "#495162";
    color9       = "#fe9ea1";
    color10      = "#98c379";
    color11      = "#f9e46b";
    color12      = "#91fff4";
    color13      = "#da70d6";
    color14      = "#bcf3ff";
    color15      = "#ffffff";
    background   = "#191323";
    foreground   = "#cccccc";
    cursor_bg    = "#e07d13";
    cursor_fg    = "#ffffff";
    selection_bg = "#3a324e";
    selection_fg = "#f4f4f4";
  };
}

