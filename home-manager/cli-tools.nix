# provides a selection of CLI tools and configuration for these tools
# TODO: should probably merge it back with home.nix

{ pkgs, lib, ... }:

{
  home.packages = [
    pkgs.aichat
    pkgs.bemoji
    pkgs.chafa
    pkgs.choose
    pkgs.dash
    pkgs.du-dust
    pkgs.expect
    pkgs.file
    pkgs.fx
    pkgs.glow
    pkgs.gowall
    pkgs.gum
    pkgs.huniq
    pkgs.hyperfine
    pkgs.jq
    pkgs.killall
    pkgs.lazygit
    pkgs.moar
    pkgs.ouch
    pkgs.pastel
    pkgs.sd
    pkgs.socat
    pkgs.uni
    pkgs.urlencode
    pkgs.watchexec
    pkgs.yj
  ];

  home.sessionVariables = {
    # WARN: for some reason widgets don't work with `--with-shell='zsh -ic'`, only with non-interactive zsh
    FZF_CTRL_T_COMMAND = "fd -- '$cdpath'";
    FZF_ALT_C_COMMAND = "fd -td -tl -- '$cdpath'";

    PAGER = "moar";
    MOAR = "--no-linenumbers --no-statusbar --scroll-left-hint=ESC[90m‹ --scroll-right-hint=ESC[90m› --terminal-fg";

    # actually should be in global zprofile/zenv, but won't bother configuring a shell i don't really use
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  };

  services = {
    pueue.enable = true;
  };

  programs = {
    atuin = {
      enable = true;
      settings = {
        update_check      = false;
        style             = "compact";
        inline_height     = 12;
        dialect           = "uk";
        keys.scroll_exits = false;
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
      # TODO use makeBinaryWrapper when https://github.com/NixOS/nixpkgs/pull/397604 is merged
      package = pkgs.writers.writeDashBin "fd"
        ''
        ${lib.getExe pkgs.fd} --follow --hidden --color=always --hyperlink=always "$@"
        '';
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
        "--column"
        "--line-number"
        "--trim"
        "--no-require-git"
        # without this, --hidden makes it search .git/ even in presence of .gitignore
        "--glob='!.git'"
      ];
    };
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

}

