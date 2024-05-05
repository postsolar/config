{ inputs, outputs, config, pkgs, system, ... }:

{

  nixpkgs.overlays = outputs.overlays;

  nixpkgs.config = {
    allowUnfreePredicate = _: true;
    allowInsecurePredicate = _: true;
  };

  imports = [
    ./zsh/zsh.nix
    ./xdg.nix
    ./theme.nix
    ./starship.nix
    ./rio.nix
    ./pueue.nix
    ./mako.nix
    ./lf/lf.nix
    ./kakoune/kakoune.nix
    ./hyprland/hyprland.nix
    ./helix/helix.nix
    ./git.nix
    ./fusuma.nix
    ./fzf.nix
    ./foot/foot.nix
    ./fish/fish.nix
    ./firefox.nix
    ./environment.nix
    ./cliphist.nix
    ./bottom.nix
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;

  home.file.".XCompose".source = config.lib.file.mkOutOfStoreSymlink ./XCompose;

  home.packages = [
    # media
    pkgs.yewtube
    pkgs.xdg-utils
    pkgs.wf-recorder
    pkgs.waypaper
    pkgs.swww
    pkgs.sioyek
    pkgs.pulseaudio
    pkgs.mpv
    pkgs.foliate
    pkgs.cinnamon.nemo-with-extensions
    pkgs.chafa
    pkgs.imv
    pkgs.flameshot
    pkgs.grim

    # cli-media-utils
    pkgs.wl-clipboard
    inputs.hyprpicker.packages.${system}.hyprpicker
    inputs.hyprland-contrib.packages.${system}.grimblast

    # cli-utils
    pkgs.watchexec
    pkgs.units
    pkgs.ugrep
    pkgs.sd
    pkgs.rlwrap
    pkgs.ripgrep
    pkgs.pastel
    pkgs.ouch
    pkgs.ncdu
    pkgs.lshw
    pkgs.lf
    pkgs.killall
    pkgs.jq
    pkgs.jc
    pkgs.hyperfine
    pkgs.huniq
    pkgs.handlr-regex
    pkgs.gum
    pkgs.glow
    pkgs.fzf
    pkgs.fx
    pkgs.file
    pkgs.fd
    pkgs.fastfetch
    pkgs.eza
    pkgs.du-dust
    pkgs.choose
    pkgs.bottom
    pkgs.starship

    # services
    pkgs.playerctl
    pkgs.pamixer
    pkgs.libnotify
    pkgs.dconf
    pkgs.distrobox
    pkgs.devenv
    inputs.nixpkgs-master.legacyPackages.${system}.nix-inspect

    # scripts
    pkgs.scripts.hyprland-center-window
    pkgs.scripts.foot-floating
    pkgs.scripts.launcher
    pkgs.scripts.unicode-picker
    pkgs.scripts."rg+fzf"
    pkgs.scripts.fzf-linewise
    pkgs.scripts.screenshot
    pkgs.scripts.random-wallpaper

    # programming
    pkgs.gh
    pkgs.cargo
    pkgs.nodejs_22
    inputs.simple-completion-lsp.defaultPackage.${system}
    # c(++)
    pkgs.gcc
    pkgs.clang-tools_17
    # yaml
    (pkgs.mkYarnPackage {
      name = "yaml-language-server";
      src = inputs.yaml-language-server;
    })
    # markdown
    pkgs.marksman
    # sh
    pkgs.nodePackages_latest.bash-language-server
    pkgs.shellcheck
    # js/ts
    pkgs.nodePackages_latest.typescript
    pkgs.nodePackages_latest.typescript-language-server
    # nix
    inputs.nil.packages.${system}.nil
    inputs.nixd.packages.${system}.nixd

    # other
    (pkgs.nvtopPackages.nvidia.override { intel = true; })
    pkgs.glxinfo
    pkgs.vulkan-tools

  ];

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--multiline"
      "--multiline-dotall"
      "--smart-case"
      "--follow"
      "--hidden"
      "--max-filesize=500K"
      "--colors=column:fg:blue"
      "--column"
      "--line-number"
      "--trim"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.atuin = {
    enable = true;
    settings = {
      update_check = false;
      style = "compact";
      inline_height = 10;
      show_preview = true;
      dialect = "uk";
      keys.scroll_exits = false;
    };
  };

  gtk = {
    enable = true;
    cursorTheme.name = "ArcMidnight-Cursors";
    cursorTheme.size = 16;
    theme.name = "phocus-gtk";
    font.name = config.theme.variableWidthFont or "SF Pro";
    font.size = 11;
  };

  home.activation.removeExtraFiles =
    ''
    rm -rf ${config.home.homeDirectory}/.nix-profile
    rm -rf ${config.home.homeDirectory}/.nix-defexpr
    rm -rf ${config.home.homeDirectory}/.gtkrc-2.0
    '';

}

