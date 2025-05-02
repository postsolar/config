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
    let version = "0.17.0"; in
    p.satty.overrideAttrs
      (n: _: {
        inherit version;
        src = p.fetchFromGitHub {
          owner = "gabm";
          repo = "Satty";
          rev = "v${version}";
          hash = "sha256-Lf/3h6Y6lKWQ8lPJZ6SCm3+w/Dc4m8yUYH7Xv0GAbqo=";
        };
        cargoHash = "sha256-aqFNIxZydyCJX2sRmuVohfyVZdDgYSh7d8UMqog0cm0=";
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit (n) pname src version;
          hash = n.cargoHash;
        };
      })
      ;

}

