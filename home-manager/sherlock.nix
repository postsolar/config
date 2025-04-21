{ inputs, system, ... }:

{
  home.packages = [
    inputs.sherlock.packages.${system}.default
  ];
}

