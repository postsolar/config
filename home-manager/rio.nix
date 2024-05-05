{ pkgs, config, ... }:

{

  programs.rio = {
    enable = true;
    package = pkgs.rio;

    settings = {
      editor = "hx";

      use-kitty-keyboard-protocol = true;

      cursor = "▇";

      blinking-cursor = false;

      hide-cursor-when-typing = true;

      ignore-selection-foreground-color = true;

      # It makes Rio look for the specified theme in the themes folder
      # ~/.config/rio/themes/<theme>.toml
      # theme = <theme>;

      # working-dir = "~";

      fonts = {
        family = config.theme.monospaceFont;
      };

      navigation = {
        mode = "TopTab";
        clickable = true;
        use-current-path = true;
        color-automation = [];
      };

      # [colors]
      # # Regular colors
      # background = '#0F0D0E'
      # black = '#4C4345'
      # blue = '#006EE6'
      # cursor = '#F38BA3'
      # cyan = '#88DAF2'
      # foreground  = '#F9F4DA'
      # green = '#0BA95B'
      # magenta = '#7B5EA7'
      # red = '#ED203D'
      # white = '#F1F1F1'
      # yellow = '#FCBA28'

      # # UI colors
      # tabs = '#12B5E5'
      # tabs-active = '#FCBA28'
      # selection-foreground = '#0F0D0E'
      # selection-background = '#44C9F0'

      # # Dim colors
      # dim-black = '#1C191A'
      # dim-blue = '#0E91B7'
      # dim-cyan = '#93D4E7'
      # dim-foreground = '#ECDC8A'
      # dim-green = '#098749'
      # dim-magenta = '#624A87'

    };
  };

}

