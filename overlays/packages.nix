inputs: f: p:

{

  apple-color-emoji =
    f.runCommandNoCC "apple-color-emoji" {}
      ''
      mkdir -p $out/share/fonts/truetype
      cp ${inputs.apple-color-emoji} $out/share/fonts/truetype/AppleColorEmoji.ttf
      '';

  satty =
    let version = "576861832b040b380a176979355f210b3caf6be6"; in
    p.satty.overrideAttrs
      (n: _: {
        inherit version;
        src = p.fetchFromGitHub {
          owner = "gabm";
          repo = "Satty";
          rev = "${version}";
          hash = "sha256-xLsWBXMIeNmY62vi3Yt88fcGX63l7gpVp9Ox5Fmm4mw=";
        };
        cargoHash = "sha256-zvE8kaju+4OOPlerg6laiBv885flT1uQwqUngm0ZiT8=";
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit (n) pname src version;
          hash = n.cargoHash;
        };
      })
      ;

  # keep it on master for now as 1) it's easy to build 2) it updates often and has quite a way to go
  gemini-cli = inputs.nixpkgs-master.legacyPackages.${f.system}.gemini-cli.overrideAttrs (o: {
    patches = (o.patches or []) ++ [ ./gemini-support-editor.patch ];
  });

}

