{ inputs, system, ... }:

{
  # TODO: will soon be in nixpkgs, see https://github.com/nixOS/nixpkgs/pull/403004
  home.packages = [
    inputs.sherlock.packages.${system}.default
  ];

  # there's a home-manager module in https://github.com/Skxxtz/sherlock/blob/main/nix/home-manager.nix
  # but it's kinda goofy, i'd just write my files directly here
}

