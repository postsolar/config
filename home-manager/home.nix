# This module is mostly for things that didn't fit elsewhere or couldn't be easily categorized.

{ inputs, outputs, config, pkgs, lib, system, ... }@ctx:

{

  nixpkgs = {
    config = {
      allowUnfreePredicate = _: true;
      allowInsecurePredicate = _: true;
    };
    overlays = outputs.overlays;
  };

  services.home-manager.autoExpire.enable = true;

  imports = [
    ./albert/albert.nix
    ./broot.nix
    ./cli-tools.nix
    ./fish/fish.nix
    ./helix/helix.nix
    ./hyprland/hyprland.nix
    ./ironbar/ironbar.nix
    ./kitty/kitty.nix
    ./lf/lf.nix
    ./mime.nix
    ./niri/niri.nix
    ./ocr.nix
    ./satty.nix
    ./sherlock.nix
    ./starship.nix
    ./swayimg.nix
    ./swaync/swaync.nix
    ./theme.nix
    ./xdg.nix
    ./sops.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "alice";
    homeDirectory = "/home/alice";
    preferXdgDirectories = true;

    shell.enableShellIntegration = false;

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
      NIXOS_OZONE_WL = 1;
      TERMINAL = "kitty";
      # BROWSER = "google-chrome-stable";
      BROWSER = "firefox";
      XCOMPOSEFILE = ./XCompose;
      # source updated hm variables on each shell init
      __HM_SESS_VARS_SOURCED = "";
      KOOHA_EXPERIMENTAL = "all";
    };

    activation.removeExtraFiles = lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
      run rm $VERBOSE_ARG -rf ${config.home.homeDirectory}/.nix-defexpr
      run rm $VERBOSE_ARG -rf ${config.home.homeDirectory}/.gtkrc-2.0
      '';

    activation.diff = lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      '';


    packages = [
      # lowPrio for it to not conflict with `programs.home-manager.enable = true`
      # needed because the latter will be ignored on `nixos-rebuild`
      (lib.lowPrio pkgs.home-manager)

      # media
      (pkgs.google-chrome.override {
        commandLineArgs = [
          "--new-window"
          "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
          "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
          "--enable-wayland-ime=true"
          "--ozone-platform-hint=auto"
        ]; })
      (pkgs.hyprshot.override { hyprland = config.wayland.windowManager.hyprland.package; })
      pkgs.brave
      pkgs.firefox
      pkgs.foliate
      pkgs.glib
      pkgs.kooha
      pkgs.nemo-with-extensions
      pkgs.nemo-preview
      pkgs.nemo-fileroller
      pkgs.obsidian
      pkgs.overskride
      pkgs.pwvucontrol
      pkgs.pulseaudio
      pkgs.telegram-desktop
      pkgs.waypaper
      pkgs.wf-recorder

      # cli media utils
      pkgs.ffmpeg-full
      pkgs.yt-dlp
      pkgs.hyprpicker
      pkgs.wl-clipboard
      pkgs.pandoc_3_6
      pkgs.scdl
      pkgs.streamrip
      pkgs.wl-kbptr

      # services
      pkgs.dconf
      pkgs.devenv
      pkgs.distrobox
      pkgs.libnotify
      pkgs.pamixer
      pkgs.playerctl

      # programming
      pkgs.gh
      pkgs.hyprls
      pkgs.just
      pkgs.lsp-ai
      pkgs.nixd
      pkgs.typescript-language-server
    ];
  };

  services = {
    blueman-applet.enable = true;
    playerctld.enable = true;
    swww.enable = true;
    network-manager-applet.enable = true;
    # NOTE copyq seems to also fully replace `wl-clipboard` but we'll keep it anyways for now for compatibility
    # also wl-paste appears to be much faster: 5ms vs 360ms for image/png, 5ms vs 85ms for text/plain (7 bytes)
    copyq = {
      enable = true;
      forceXWayland = false;
    };
  };

  programs = {
    bun.enable = true;
    foot = {
      enable = true;
      server.enable = true;
      settings = import ./foot.nix ctx;
    };
    fuzzel = {
      enable = true;
      settings = import ./fuzzel.nix ctx;
    };
    fzf-window = {
      enable = true;
      terminalCommand = "footclient -E";
    };
    gh.enable = true;
    git = {
      enable = true;
      userEmail = "120750161+postsolar@users.noreply.github.com";
      userName = "postsolar";

      difftastic.enable = true;
      difftastic.display = "side-by-side";
    };
    home-manager.enable = true;
    mpv = {
      enable = true;
      scriptOpts = {
        thumbfast = {
          network = "yes";
        };
      };
      scripts = [
        pkgs.mpvScripts.mpris
        pkgs.mpvScripts.uosc
        pkgs.mpvScripts.thumbfast
      ];
    };
    swayimg.enable = true;
  };

  # todo: see if fcitx could be replaced with ibus (although fcitx has some extras which are rather nice to have)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        pkgs.fcitx5-lua
      ];
    };
  };

}
