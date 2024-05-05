# flameshot releases come rather infrequently, but
# on dev branch there accumulated a number of desirable commits,
# including some initial hyprland support

final: prev:

let
  flameshot-src = final.fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
    hash = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
  };

  update = old: {
    src = flameshot-src;
    patches = old.patches or [] ++ [ ./flameshot_no-grim-notif.patch ];
    cmakeFlags = old.cmakeFlags ++ [ "-DUSE_WAYLAND_GRIM=true" ];
  };

in
{
  flameshot = prev.flameshot.overrideAttrs update;
}

