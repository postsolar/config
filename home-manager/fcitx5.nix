{ pkgs, ... }:

{

  home.sessionVariables = {
    # https://github.com/abenz1267/walker/issues/258
    GTK_IM_MODULE = "fcitx";
  };

  # TODO:
  # see if fcitx could be replaced with ibus when nixpkgs updates ibus to 1.5.32
  # see ../nixos/configuration.nix for pr tracker links
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        pkgs.fcitx5-lua
      ];
    };
  };

}

