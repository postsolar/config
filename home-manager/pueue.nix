{ config, pkgs, ... }:

# BUG currently the systemd unit is broken for some reason
# notifier script wont work

let
  notifier = pkgs.writeScript "pueue-notifier.zsh"
    ''
    #! ${config.programs.zsh.package}/bin/zsh

    wd=$1
    command="$wd : $2"

    s=$(( $4 - $3 ))
    h=$(( s / 3600 ))
    s=$(( s % 3600 ))
    m=$(( s / 60 ))
    s=$(( s % 60 ))
    dur=(''${h}h ''${m}m ''${s}s)
    dur=''${dur:#0*}

    case $5 in
      0) notify-send "Done in $dur" $command ;;
      *) notify-send "Failed ($5) after $dur" $command ;;
    esac
    '';
in

{

  home.packages = [ pkgs.pueue ];

  services.pueue = {
    enable = true;
    settings = {
      daemon = {
        shell_command = [ "zsh" "-c" "{{ pueue_command_string }}" ];
        callback = "${notifier} \"{{ path }}\" \"{{ command }}\" {{ start }} {{ end }} {{ exit_code }}";
      };
    };
  };

}

