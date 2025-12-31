{ config, ... }:

{
  imports = [
    ./keybindings.nix
  ];

  xdg.configFile."fish/functions.fish".source = ./functions.fish;

  programs.fish = {
    enable = true;
    shellInit = # fish
      ''
      if test -x /usr/libexec/path_helper
        eval (/usr/libexec/path_helper -s | string replace -r '^PATH=' 'set -gx PATH ' | string replace -r '^(.*); export PATH$' '$1')
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      # Work around Nix fish profile bug: NIX_PROFILES is a single string, not a list.
      # Code in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish is wrong and bugged - please file a report
      if test -z "$NIX_SSL_CERT_FILE"
        for i in (echo $NIX_PROFILES | string split ' ')
          if test -e "$i/etc/ssl/certs/ca-bundle.crt"
            set -gx NIX_SSL_CERT_FILE "$i/etc/ssl/certs/ca-bundle.crt"
          end
        end
      end

      # Another inconsistency between POSIX nix-daemon.sh and nix-daemon.fish, it does not correctly set XDG data dirs
      if test -n "$XDG_DATA_DIRS"
        set -gx XDG_DATA_DIRS "$XDG_DATA_DIRS:$HOME/.nix-profile/share"
      else
        set -gx XDG_DATA_DIRS "/usr/local/share:/usr/share:$HOME/.nix-profile/share"
      end

      # Since we set XDG_DATA_DIRS here, we're too late to properly auto load completions from there. Load them manually here.
      for dir in (echo $NIX_PROFILES | string split ' ')/share/fish/vendor_completions.d
        if test -d $dir; and not contains $dir $fish_complete_path
          set -g fish_complete_path $fish_complete_path $dir
        end
      end
      '';

    interactiveShellInit = # fish
      ''
      source ${config.xdg.configHome}/fish/functions.fish
      '';
  };
}
