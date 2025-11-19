{ inputs, system, pkgs, ... }:

# TODO remember why i still use it

{

  home.sessionVariables = {
    # https://github.com/abenz1267/walker/issues/258
    GTK_IM_MODULE = "fcitx";
  };

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
