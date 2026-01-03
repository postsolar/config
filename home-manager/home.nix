{ config, pkgs, lib, flakeDir, ... }:

{
  nixpkgs.config.allowUnfreePredicate = _: true;

  imports = [
    ./fish/fish.nix
    ./helix.nix
    ./kitty.nix
    ./paneru.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alan";
  home.homeDirectory = "/Users/alan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.choose
    pkgs.claude-code
    pkgs.codex
    pkgs.difftastic
    pkgs.dust
    pkgs.eza
    pkgs.expect
    pkgs.fd
    pkgs.fx
    pkgs.fzf
    pkgs.gemini-cli
    pkgs.glow
    pkgs.huniq
    pkgs.hyperfine
    pkgs.jq
    pkgs.just
    pkgs.moor
    pkgs.nixd
    pkgs.nvd
    pkgs.opencode
    pkgs.ouch
    pkgs.ripgrep
    pkgs.sd
    pkgs.socat
    pkgs.telegram-desktop
    pkgs.typescript-language-server
    pkgs.uni
    pkgs.vscode-langservers-extracted
    pkgs.watchexec
    pkgs.yazi
    pkgs.yj
    pkgs.yq
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
    __HM_SESS_VARS_SOURCED = "";
    EDITOR = "hx";
    PAGER = "moor";
    MOOR = "--no-linenumbers --no-statusbar --scroll-left-hint=ESC[90m‹ --scroll-right-hint=ESC[90m› --terminal-fg";
    STARSHIP_LOG = "error";
  };

  xdg.enable = true;

  home.activation.diff = lib.hm.dag.entryAfter [ "writeBoundary" ]
    ''
    [[ -v oldGenPath ]] && ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    '';

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

    bun.enable = true;

    difftastic = {
      enable = true;
      options.display = "side-by-side";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza.enable = true;
    fd.enable = true;
    gh.enable = true;

    nh = {
      enable = true;
      homeFlake = flakeDir;
    };

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

    git = {
      enable = true;
      settings.user = {
        name = "postsolar";
        email = "120750161+postsolar@users.noreply.github.com";
      };
    };

    starship = {
      enable = true;
      settings = {
        command_timeout = 1000;

        character = {
          success_symbol = " [-](bold green) ";
          error_symbol = " [-](bold red) ";
        };

        directory = {
          format = " [$path]($style)[$read_only]($read_only_style) ";
          home_symbol = "⌂";
        };

        cmd_duration = {
          min_time = 500;
          format = " [⧗$duration]($style) ";
          style = "dimmed 8";
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
