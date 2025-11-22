{ inputs, outputs, config, pkgs, pkgs-master, lib, flakeDir, system, ... }:

let
  link = f: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home-manager/${f}";
in

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
    ./browsers.nix
    ./claude.nix
    ./clipboard.nix
    ./fcitx5.nix
    ./fish/fish.nix
    ./helix/helix.nix
    ./hypridle.nix
    ./hyprland/hyprland.nix
    ./ironbar/ironbar.nix
    ./kitty.nix
    ./mime.nix
    ./satty.nix
    ./smile.nix
    ./starship.nix
    ./swaync/swaync.nix
    ./theme.nix
    ./walker/walker.nix
    ./xdg.nix
    ./yazi.nix

    inputs.wayland-pipewire-idle-inhibit.homeModules.default
  ];

  home = {
    stateVersion = "24.11";
    username = "alice";
    homeDirectory = "/home/alice";
    preferXdgDirectories = true;

    shell.enableShellIntegration = false;

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;

      # source updated hm variables on each shell init
      __HM_SESS_VARS_SOURCED = "";

      NIXOS_OZONE_WL = 1;

      # Force GTK4 to use Cairo renderer instead of Vulkan/OpenGL to fix flickering issues
      # TODO: Check if this is still needed with future GTK4/driver updates
      GSK_RENDERER = "cairo";

      TERMINAL = "kitty";

      XCOMPOSEFILE = link "./XCompose";

      KOOHA_EXPERIMENTAL = "all";

      PAGER = "moor";
      MOOR = "--no-linenumbers --no-statusbar --scroll-left-hint=ESC[90m‹ --scroll-right-hint=ESC[90m› --terminal-fg";
    };

    activation.removeExtraFiles = lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
      run rm $VERBOSE_ARG -rf ${config.home.homeDirectory}/.nix-defexpr
      run rm $VERBOSE_ARG -rf ${config.home.homeDirectory}/.gtkrc-2.0
      '';

    activation.diff = lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
      [[ -v oldGenPath ]] && ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      '';

    packages = [
      # lowPrio for it to not conflict with `programs.home-manager.enable = true`
      # needed because the latter will be ignored on `nixos-rebuild`
      (lib.lowPrio pkgs.home-manager)

      pkgs.aichat
      pkgs.chafa
      pkgs.cheese
      pkgs.choose
      pkgs.dash
      pkgs.difftastic
      pkgs.distrobox
      pkgs.dust
      pkgs.eog
      pkgs.expect
      pkgs.ffmpeg-full
      pkgs.file
      pkgs.fx
      # needs a couple updates
      pkgs-master.gemini-cli
      pkgs.gh
      pkgs.glib
      pkgs.glow
      pkgs.gradia
      (pkgs.grimblast.override { hyprland = inputs.hyprland.packages.${system}.hyprland; })
      pkgs.gum
      pkgs.huniq
      pkgs.hyperfine
      pkgs.hyprls
      pkgs.hyprpicker
      pkgs.jq
      pkgs.just
      pkgs.killall
      pkgs.libnotify
      pkgs.mixxx
      pkgs.moor
      pkgs.nemo-fileroller
      pkgs.nemo-preview
      pkgs.nemo-with-extensions
      pkgs.nixd
      pkgs.nodePackages.sass
      pkgs.ouch
      pkgs.overskride
      pkgs.pamixer
      pkgs.pandoc
      pkgs.pastel
      pkgs.playerctl
      pkgs.pulseaudio
      pkgs.pwvucontrol
      pkgs.sd
      pkgs.socat
      pkgs.telegram-desktop
      pkgs.typescript-language-server
      pkgs.uni
      pkgs.urlencode
      pkgs.vscode-langservers-extracted
      pkgs.watchexec
      pkgs.wf-recorder
      pkgs.wlinhibit
      # TODO re-enable when build no longer fails
      # pkgs.xpdf
      pkgs.yek
      pkgs.yj
      pkgs.yq
    ];
  };

  services = {
    # ironbar's bluetooth module is a bit nicer
    # blueman-applet.enable = true;
    playerctld.enable = true;
    swww.enable = true;
    network-manager-applet.enable = true;
    caffeine.enable = true;

    wayland-pipewire-idle-inhibit = {
      enable = true;
      package = pkgs.wayland-pipewire-idle-inhibit;
      settings = {};
    };
  };

  programs = {
    bottom = {
      enable = true;
      settings.flags = {
        default_widget_type        = "proc";
        expanded                   = true;
        hide_table_gap             = true;
        left_legend                = true;
        regex                      = true;
        mem_as_value               = true;
        show_table_scroll_position = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza.enable = true;
    fd.enable = true;
    foliate.enable = true;
    fzf = {
      enable = true;
      defaultOptions = [
        "--with-shell='zsh -c'"
        "--multi"
        "--cycle"
        "--ansi"
        "--reverse"
        "--border=none"
        "--wrap"
        "--gap-line=―"
        "--pointer=' '"
        "--tabstop=4"
        "--prompt='» '"
        "--preview-label-pos=-2:bottom"
        "--preview-window=,wrap,border-left,cycle"
      ];
      colors = {
        "fg"         = "-1";      # Text
        "bg"         = "-1";      # Background
        "hl"         = "1";       # Highlighted substrings
        "current-fg" = "-1";      # (fg+) Text (current line)
        "current-bg" = "5";       # (bg+) Background (current line)
        "current-hl" = "1";       # (hl+) Highlighted substrings (current line)
        "info"       = "-1:dim";  # Info line (match counters)
        "border"     = "8:dim";   # Border around the window (−−border and −−preview)
        "gutter"     = "-1";      # Gutter on the left
        "query"      = "-1:bold"; # (input−fg) Query string
        "prompt"     = "1";       # Prompt
        "pointer"    = "1";       # Pointer to the current line
        "marker"     = "1";       # Multi−select marker
        "spinner"    = "1";       # Streaming input indicator
      };
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--multiline"
        "--multiline-dotall"
        "--smart-case"
        "--pcre2"
        "--follow"
        "--hidden"
        "--max-filesize=500K"
        "--colors=column:fg:blue"
      ];
    };
    bun.enable = true;
    gh.enable = true;
    git = {
      enable = true;
      settings.user = {
        email = "120750161+postsolar@users.noreply.github.com";
        name = "postsolar";
      };
    };
    difftastic = {
      enable = true;
      git.enable = true;
      options.display = "side-by-side";
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
  };

  xdg.configFile = {
    "aichat/config.yaml".source = link "./aichat-config.yaml";
  };

  systemd.user.settings = {
    Manager.DefaultEnvironment = {
      PATH = "/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH";
    };
  };

}
