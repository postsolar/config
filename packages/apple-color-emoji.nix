src: { stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "AppleColorEmoji";
  version = "git";

  inherit src;

  dontUnpack = true;

  buildPhase =
    ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
    '';
}

