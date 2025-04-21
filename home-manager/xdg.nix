{ pkgs, ... }:

{
  xdg = {
    enable = true;
    autostart.enable = true;

    # to check on portal status: nix run nixpkgs#door-knocker
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal
      ];
    };
  };
}

