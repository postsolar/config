inputs: f: p:

{

  apple-color-emoji =
    f.callPackage
      (import ../packages/apple-color-emoji.nix inputs.apple-color-emoji-src)
      {}
      ;

  wl-kbptr =
    p.wl-kbptr.overrideAttrs
      (_: _: {
        src = inputs.wl-kbptr;
        version = inputs.wl-kbptr.rev;
      })
      ;

  satty =
    let version = "a1bcb1f30926c40436e570c6b98549585290e536"; in
    p.satty.overrideAttrs
      (n: _: {
        inherit version;
        src = p.fetchFromGitHub {
          owner = "gabm";
          repo = "Satty";
          rev = "${version}";
          hash = "sha256-t66ygjhzFhS6FlerpXuNtguNdQB/L0nAj6KcIXyRGXE=";
        };
        cargoHash = "sha256-hvJOjWD5TRXlDr5KfpFlzAi44Xd6VuaFexXziXgDLCk=";
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit (n) pname src version;
          hash = n.cargoHash;
        };
      })
      ;

}

