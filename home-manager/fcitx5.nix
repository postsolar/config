{ inputs, system, pkgs, ... }:

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
        # inputs.im-emoji-picker-fcitx.packages.${system}.default
      ];
    };
  };

}

