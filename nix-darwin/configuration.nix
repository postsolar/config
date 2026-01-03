# TODO https://freedium-mirror.cfd/https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
# also seen in https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/minimal/modules/nix-core.nix

{ pkgs, ... }:

{
  system.stateVersion = 6;

  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

}

