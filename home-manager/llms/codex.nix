{ config, flakeDir, pkgs, ... }:

{
  home.packages = [
    pkgs.codex
  ];

  home.file.".codex/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home-manager/llms/codex-config.toml";

  home.file.".config/fish/conf.d/codex-env.fish".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/secrets/codex-env.fish";
}
