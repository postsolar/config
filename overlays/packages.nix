inputs: f: p:

{

  apple-color-emoji =
    f.callPackage
      ../packages/apple-color-emoji.nix
      { inherit (inputs) apple-color-emoji-src; }
      ;

  wl-kbptr =
    p.wl-kbptr.overrideAttrs
      (_: _: {
        src = inputs.wl-kbptr;
        version = inputs.wl-kbptr.rev;
      })
      ;

}

