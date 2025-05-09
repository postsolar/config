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
    let version = "0.18.0"; in
    p.satty.overrideAttrs
      (n: _: {
        inherit version;
        src = p.fetchFromGitHub {
          owner = "gabm";
          repo = "Satty";
          rev = "v${version}";
          hash = "sha256-qsehxmx+iQKG70Es2I+G8hs4G56e/PuPPenNeEQ4sGQ=";
        };
        cargoHash = "sha256-VQ8BwEeDM9Dll6GIwXH2wHWwRKJxk3gTrxZ95pFaH4c=";
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit (n) pname src version;
          hash = n.cargoHash;
        };
      })
      ;

}

