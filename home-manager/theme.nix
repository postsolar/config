{ config, pkgs, ... }:

{

  # default | prefer-dark | prefer-light
  dconf.settings."org/gnome/desktop/interface".color-scheme = "default";

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [ "MonoLisa" ];
    defaultFonts.sansSerif = [ "SF Pro" ];
    defaultFonts.serif = [ "SF Pro" ];
    defaultFonts.emoji = [ "Apple Color Emoji" ];
  };

  gtk = {
    enable = true;
    theme.name = "Orchis-Pink-Dark-Compact";
    theme.package = pkgs.orchis-theme.override { tweaks = [ "black" ]; };
    font.name = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
    iconTheme.package = pkgs.vimix-icon-theme;
    iconTheme.name = "Vimix-black";

    gtk4.extraCss =
      # css
      ''
      '';
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    # TODO: codegen a QT phocus
    # the word on the street is qt theming is easy so shouldn't be much work
    "Kvantum/kvantum.kvconfig".text =
      ''
      [General]
      theme=MateriaDark
      '';
    # not best but ok, might tweak it one day
    "Kvantum/MateriaDark".source = "${pkgs.materia-kde-theme}/share/Kvantum/MateriaDark";
  };

  home.pointerCursor = rec {
    size = 12;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    hyprcursor.enable = true;
    hyprcursor.size = size;
    gtk.enable = true;
  };
}

