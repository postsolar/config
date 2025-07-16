{ inputs, lib, pkgs, config, ... }:

{

  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;

    package = pkgs.nixVersions.latest;

    registry =
      lib.mapAttrs (_: f: { flake = f; })
        <| lib.filterAttrs (_: lib.isType "flake") inputs
      ;

    # don't know how it differs from `nix.settings.auto-optimise-store`,
    # but setting it anyways just in case
    optimise = {
      automatic = true;
      dates = [ "1w" ];
    };

    # `$NIX_PATH` is set without this too, to `flake nixpkgs`,
    # but `nixd` docs recommend setting it like this
    nixPath = [ "nixpkgs=${ inputs.nixpkgs }" ];

    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      builders-use-substitutes = true;
      auto-optimise-store = true;
      trusted-users = [ "root" "alice" "@wheel" ];

      substituters = [
        "https://anyrun.cachix.org"
        "https://cache.garnix.io"
        "https://cache.nixos.org"
        "https://helix.cachix.org"
        "https://hyprland.cachix.org"
        "https://niri.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://walker.cachix.org"
        "https://walker-git.cachix.org"
      ];

      trusted-substituters = config.nix.settings.substituters;

      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
        "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      ];
    };
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text =
      ''
      ${lib.getExe pkgs.nvd} --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      '';

    # could also do it with `nix store diff-closures`
    # text =
    #   ''
    #   nix store diff-closures /run/current-system "$systemConfig"
    #   '';
  };

  environment.systemPackages = [
    pkgs.nvd
    pkgs.nix-output-monitor
  ];

  programs.command-not-found.enable = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "-d";
    # WARN has to be changed on directory move
    flake = "/data/nix";
  };

}

