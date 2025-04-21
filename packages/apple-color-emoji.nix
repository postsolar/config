{ stdenvNoCC, apple-color-emoji-src }:

stdenvNoCC.mkDerivation {
  pname = "AppleColorEmoji";
  version = "git";

  src = apple-color-emoji-src;

  dontUnpack = true;

  buildPhase =
    ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
    '';
}

