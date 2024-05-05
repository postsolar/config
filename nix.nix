{ inputs, lib, pkgs, config, ... }:

{

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nixVersions.latest;

  nix.channel.enable = false;

  nix.registry =
    (lib.mapAttrs (_: f: { flake = f; }))
      ((lib.filterAttrs (_: lib.isType "flake")) inputs)
    ;

  # don't know how it differs from `nix.settings.auto-optimise-store`,
  # but setting it anyways just in case
  nix.optimise.automatic = true;

  # `$NIX_PATH` is set without this too, to `flake nixpkgs`,
  # but `nixd` docs recommend setting it like this
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    trusted-users = [ "root" "@wheel" ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];

    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"
    ];
  };

  programs.command-not-found.enable = false;

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
    '';
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "-d";
    flake = config.users.users.me.home + "/nix";
  };

}

