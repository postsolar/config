{ inputs, ... }:

# https://github.com/vicinaehq/vicinae/blob/main/nix/module.nix

# TODO configure

{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;
    autoStart = true;
  };
}
