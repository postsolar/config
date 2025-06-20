{ inputs, outputs, config, pkgs, lib, system, ... }:

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
    ./broot.nix
    ./clipboard.nix
    ./fcitx5.nix
    ./fish/fish.nix
    ./fzf-window.nix
    ./helix/helix.nix
    ./hypridle.nix
    ./hyprland/hyprland.nix
    ./ironbar/ironbar.nix
    ./kitty.nix
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
    ./walker.nix
    ./wl-kbptr.nix
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

      TERMINAL = "kitty";

      BROWSER = "firefox";

      XCOMPOSEFILE = ./XCompose;

      KOOHA_EXPERIMENTAL = "all";

      # WARN: for some reason widgets don't work with `--with-shell='zsh -ic'`, only with non-interactive zsh
      FZF_CTRL_T_COMMAND = "fd -- '$cdpath'";
      FZF_ALT_C_COMMAND = "fd -td -tl -- '$cdpath'";

      PAGER = "moar";
      MOAR = "--no-linenumbers --no-statusbar --scroll-left-hint=ESC[90m‹ --scroll-right-hint=ESC[90m› --terminal-fg";
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

      (pkgs.google-chrome.override {
        commandLineArgs = [
          "--new-window"
          "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
          "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
          "--enable-wayland-ime=true"
          "--ozone-platform-hint=auto"
        ];
      })
      (pkgs.hyprshot.override { hyprland = config.wayland.windowManager.hyprland.package; })
      pkgs.aichat
      pkgs.bemoji
      pkgs.better-control
      (pkgs.brave.override {
        commandLineArgs = [
          "--enable-features=TouchpadOverscrollHistoryNavigation"
          "--enable-wayland-ime=true"
        ];
      })
      pkgs.chafa
      pkgs.choose
      pkgs.dash
      pkgs.dconf
      pkgs.devenv
      pkgs.distrobox
      pkgs.du-dust
      pkgs.expect
      pkgs.ffmpeg-full
      pkgs.file
      pkgs.firefox
      pkgs.fx
      pkgs.gh
      pkgs.gimp3
      pkgs.glib
      pkgs.glow
      pkgs.gowall
      pkgs.gum
      pkgs.huniq
      pkgs.hyperfine
      pkgs.hyprls
      pkgs.hyprpicker
      pkgs.jq
      pkgs.jtbl
      pkgs.just
      pkgs.killall
      pkgs.kooha
      pkgs.lazygit
      pkgs.libinput
      pkgs.libinput-gestures
      pkgs.libnotify
      pkgs.libxkbcommon
      pkgs.moar
      pkgs.mutagen
      pkgs.nemo-fileroller
      pkgs.nemo-preview
      pkgs.nemo-with-extensions
      pkgs.nixd
      pkgs.nodePackages.sass
      pkgs.nwg-wrapper
      pkgs.obsidian
      pkgs.ouch
      pkgs.overskride
      pkgs.pamixer
      pkgs.pandoc
      pkgs.pastel
      pkgs.playerctl
      pkgs.pulseaudio
      pkgs.pwvucontrol
      pkgs.scdl
      pkgs.sd
      pkgs.smile
      pkgs.socat
      pkgs.streamrip
      pkgs.tdl
      pkgs.telegram-desktop
      pkgs.typescript-language-server
      pkgs.uni
      pkgs.urlencode
      pkgs.vivaldi
      pkgs.vscode-langservers-extracted
      pkgs.watchexec
      pkgs.waypaper
      pkgs.wf-recorder
      pkgs.wlinhibit
      pkgs.wl-kbptr
      pkgs.yj
      pkgs.yt-dlp
      pkgs.ytmdl
    ];
  };

  services = {
    blueman-applet.enable = true;
    playerctld.enable = true;
    swww.enable = true;
    network-manager-applet.enable = true;
    pueue.enable = true;
    caffeine.enable = true;

    wayland-pipewire-idle-inhibit = {
      enable = true;
      settings = {};
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings = {
        update_check      = false;
        style             = "compact";
        inline_height     = 12;
        dialect           = "uk";
        keys = {
          scroll_exits = false;
          exit_past_line_start = false;
          accept_past_line_end = false;
        };
        history_filter    = [ "^\s+" ];
      };
    };
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
    fd = {
      enable = true;
      # use a wrapper instead of `programs.fd.extraOptions` because it works via
      # shell aliases which leads to surprises when used outside of a shell
      package = pkgs.writers.writeDashBin "fd"
        ''
        ${lib.getExe pkgs.fd} --follow --hidden --color=always --hyperlink=always "$@"
        '';
    };
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
        "--column"
        "--line-number"
        "--trim"
        "--no-require-git"
        # without this, --hidden makes it search .git/ even in presence of .gitignore
        "--glob='!.git'"
      ];
    };
    bun.enable = true;
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

  # ref: https://github.com/sharkdp/fd/issues/1150
  # ref: https://github.com/BurntSushi/ripgrep/issues/2366
  # basically the solution is still to have per-directory ignore files
  # alternatively, since it's only the `~/.config` that requires access,
  # set XDG_CONFIG_HOME to ~/config, and never use --hidden with anything
  home.file.".ignore".text =
    ''
    .npm
    .cache
    .config/google-chrome
    .local/share
    .local/state
    .mozilla
    .nv
    .pki
    '';

  xdg.configFile = {
    "aichat/config.yaml".source = ./aichat-config.yaml;
  };

  systemd.user.settings = {
    Manager.DefaultEnvironment = {
      PATH = "/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH";
    };
  };

}
