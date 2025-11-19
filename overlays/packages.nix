inputs: f: p:

{

  apple-color-emoji =
    f.runCommand "apple-color-emoji" {}
      ''
      mkdir -p $out/share/fonts/truetype
      cp ${inputs.apple-color-emoji} $out/share/fonts/truetype/AppleColorEmoji.ttf
      '';

}

