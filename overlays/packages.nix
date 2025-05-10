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
    let version = "9b5fc3ddd4016efc768ff4a6830426a9df4777ff"; in
    p.satty.overrideAttrs
      (n: _: {
        inherit version;
        src = p.fetchFromGitHub {
          owner = "gabm";
          repo = "Satty";
          rev = "${version}";
          hash = "sha256-lgPqM/rdh3m3fRXzmO9uSGZMQmbAUFvDm4JovLRAR+M=";
        };
        cargoHash = "sha256-VQ8BwEeDM9Dll6GIwXH2wHWwRKJxk3gTrxZ95pFaH4c=";
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit (n) pname src version;
          hash = n.cargoHash;
        };
      })
      ;

}

