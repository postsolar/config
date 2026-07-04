# TODO https://freedium-mirror.cfd/https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
# also seen in https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/minimal/modules/nix-core.nix

{ inputs, pkgs, config, lib, ... }:

{
  system = {
    stateVersion = 6;
    primaryUser = "alan";
  };

  # TODO set up auto gc / auto optimize
  nix = {
    # TODO set to pkgs.lix when it's not broken anymore
    package = inputs.nixpkgs-25-11-darwin.legacyPackages."aarch64-darwin".lix;

    settings = {
      experimental-features = "nix-command flakes";
    };

    channel.enable = false;
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text =
      ''
      ${lib.getExe pkgs.nvd} diff /run/current-system "$systemConfig"
      '';
  };

  users.knownUsers = [
    config.system.primaryUser
  ];

  users.users.${config.system.primaryUser} = {
    uid = 501;
    shell = config.programs.fish.package;
  };

  environment.shells = [ config.programs.fish.package ];
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  environment.systemPackages = [
    pkgs.git-crypt
    pkgs.kanata-with-cmd
    pkgs.ntfs3g
    (pkgs.writeShellScriptBin "copyq" ''
      exec /Applications/CopyQ.app/Contents/MacOS/CopyQ "$@"
    '')
  ];

  homebrew = {
    enable = true;

    brews = [
      "mole"
      {
        name = "jundot/omlx/omlx";
        # start_service = true;
      }
    ];

    taps = [
      "dodoapps/tap"
      "thusvill/livewallpaper"
      "xykong/tap"
      {
        name = "jundot/omlx";
        clone_target = "https://github.com/jundot/omlx";
      }
    ];

    casks = [
      {
        name = "bettershot";
      }
      { name = "brave-browser@beta"; }
      { name = "cursorcerer"; }
      # TODO: cask is deprecated and slated for removal on 2026-09-01
      {
        name = "copyq";
        postinstall = "/usr/bin/xattr -cr /Applications/CopyQ.app && /usr/bin/codesign --force --deep --sign - /Applications/CopyQ.app";
      }
      {
        name = "dodoapps/tap/dodoshot";
        postinstall = "/usr/bin/xattr -cr /Applications/DodoShot.app";
      }
      { name = "finetune"; }
      { name = "flux-markdown"; }
      { name = "gimp"; }
      { name = "karabiner-elements"; }
      { name = "kitty"; }
      {
        name = "livewallpaper";
        postinstall = "/usr/bin/xattr -cr /Applications/LiveWallpaper.app";
      }
      { name = "lm-studio"; }
      { name = "macfuse"; }
      { name = "middleclick"; }
      # TODO: switch back to Home Manager's pkgs.telegram-desktop once it is cached/building again on Darwin.
      { name = "telegram"; }
    ];
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  security.sudo.extraConfig = # sudoers
    ''
    %admin ALL=(ALL) NOPASSWD: ALL # no condom edition
    '';

  security.pam.services.sudo_local.touchIdAuth = true;

  services.postgresql = {
    enable = true;
  };

}
