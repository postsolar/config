{ config, pkgs, lib, flakeDir, ... }:

{
  nixpkgs.config.allowUnfreePredicate = _: true;

  imports = [
    ./fish/fish.nix
    ./llms/llms.nix
    ./helix.nix
    ./kanata/kanata.nix
    ./kitty.nix
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
    # pkgs.bitwarden-desktop # TODO re-enable when it's not broken anymore, somewhere in June, probably this: https://github.com/NixOS/nixpkgs/issues/521305
    pkgs.choose
    pkgs.difftastic
    pkgs.dust
    pkgs.eza
    pkgs.expect
    pkgs.fd
    pkgs.ffmpeg
    pkgs.fx
    pkgs.fzf
    pkgs.git-crypt
    pkgs.glow
    pkgs.huniq
    pkgs.hyperfine
    pkgs.jq
    pkgs.just
    pkgs.moor
    pkgs.nixd
    pkgs.nvd
    pkgs.ouch
    pkgs.ripgrep
    pkgs.raycast
    pkgs.sd
    pkgs.socat
    pkgs.typescript-language-server
    pkgs.uni
    pkgs.vlc-bin
    pkgs.vscode-langservers-extracted
    pkgs.watchexec
    (pkgs.yazi.override { ffmpeg-headless = pkgs.ffmpeg; })
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
      # as nh doesnt have a nix-darwin module, we set it here
      darwinFlake = flakeDir;
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

    fish.functions.mount_adata_ssd_ntfs = # fish
      ''
      set -l mountpoint "/Volumes/ADATA NTFS"
      set -l label "ADATA NTFS"
      set -l uid (id -u)
      set -l gid (id -g)
      set -l ntfs3g /run/current-system/sw/bin/ntfs-3g
      set -l ntfsfix /run/current-system/sw/bin/ntfsfix
      set -l ntfslabel /run/current-system/sw/bin/ntfslabel
      set -l device

      if not test -x "$ntfs3g"
        echo "ntfs-3g is not available at $ntfs3g" >&2
        return 1
      end

      set -l mount_line (mount | awk -v mp="$mountpoint" 'index($0, " on " mp " ") { print; exit }')
      if test -n "$mount_line"
        if string match -q '* (macfuse,*' "$mount_line"
          echo "$mountpoint is already mounted via ntfs-3g"
          return 0
        end

        set device (printf '%s\n' "$mount_line" | awk '{ print $1 }')
        sudo /sbin/umount "$mountpoint"; or sudo /sbin/umount -f "$mountpoint"; or return 1
      else
        for candidate in /dev/disk*s*
          set -l candidate_label (sudo "$ntfslabel" "$candidate" 2>/dev/null)
          if test "$candidate_label" = "$label"
            set device "$candidate"
            break
          end
        end
      end

      if test -z "$device"
        echo "Could not find NTFS volume labelled '$label'" >&2
        return 1
      end

      sudo /bin/mkdir -p "$mountpoint"; or return 1
      sudo "$ntfsfix" -d "$device"; or return 1
      sudo "$ntfs3g" "$device" "$mountpoint" \
        -o "local,allow_other,noappledouble,noapplexattr,volname=$label,uid=$uid,gid=$gid,big_writes,noatime,delay_mtime=60,recover"
      '';

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
