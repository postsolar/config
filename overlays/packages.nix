inputs: f: p:

{

  apple-color-emoji =
    f.callPackage
      ../packages/apple-color-emoji.nix
      { inherit (inputs) apple-color-emoji-src; }
      ;

  flameshot =
    p.flameshot.override { enableWlrSupport = true; };

  wl-kbptr =
    p.wl-kbptr.overrideAttrs
      (_: _: {
        src = inputs.wl-kbptr;
        version = inputs.wl-kbptr.rev;
      })
      ;

  # # build failure on 9.1.0, so use an updated version
  # # https://nixpk.gs/pr-tracker.html?pr=398926
  # copyq =
  #   inputs.nixpkgs-master.legacyPackages.${f.system}.copyq;

  # build failure, so use an updated version
  # https://nixpk.gs/pr-tracker.html?pr=399990
  streamrip =
    inputs.nixpkgs-master.legacyPackages.${f.system}.streamrip;

}

