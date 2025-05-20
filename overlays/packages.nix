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
    let version = "45741b69a8efc60bb735ec256df3c9d90d8edda6"; in
    p.satty.overrideAttrs
      (n: _: {
        inherit version;
        src = p.fetchFromGitHub {
          owner = "gabm";
          repo = "Satty";
          rev = "${version}";
          hash = "sha256-58NlOuOYEnHqwVPoDx086mw8cj5cSGVax2lRd0we9qs=";
        };
        cargoHash = "sha256-hvJOjWD5TRXlDr5KfpFlzAi44Xd6VuaFexXziXgDLCk=";
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit (n) pname src version;
          hash = n.cargoHash;
        };
      })
      ;

}

