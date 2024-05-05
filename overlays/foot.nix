{ inputs, system }:

final: prev:

{
  foot =
    inputs.nixpkgs-wayland.packages.${system}.foot.overrideAttrs
      (oldAttrs: {
        patches = [
          # enable kitty-style underlines
          (final.fetchurl {
            url = "https://codeberg.org/dnkl/foot/pulls/1099.patch";
            hash = "sha256-NgZpocohV67mr8vpIuB3vlxjpIT50TO0p7b/2fYq/js=";
          })
        ];

        # enable kitty-style underlines
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dext-underline=enabled"];

        # switch to the latest commit before kitty kb protocol support
        # got broken on master. issue: https://codeberg.org/dnkl/foot/issues/1642
        # TODO switch back to master when programs start working again
        src = inputs.foot-kkbprotocol-works;

      })
    ;
}

