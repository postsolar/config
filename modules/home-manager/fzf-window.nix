{ config, lib, pkgs, ... }:

# Spawn FZF in a new terminal window and get the output
#
# Controllable via `FZF_DEFAULT_OPTS` and accepts stdin.
# All arguments are passed back to FZF.
# FZF package tracks `config.programs.fzf.package`.

let

  fzf = lib.getExe config.programs.fzf.package;

  cfg = config.programs.fzf-window;

  # this can be done without fifos, directly with a neat single-line `>/proc/$$/fd/1`,
  # but fifos allow for the terminal command to return immediately (e.g. `kitty -1`).
  # another way to achieve this is to use `kill -s STOP $$` after the terminal command and
  # `kill -s CONT $$` after the fzf command, but it results in annoying "Job has stopped"
  # notifications in calling shells
  script =
    pkgs.writers.writeDashBin
      "fzf-window"
      ''
      outputFifo=$(mktemp --dry-run --tmpdir --suffix=.fifo fzf-window-output.XXXX)
      mkfifo $outputFifo
      ${cfg.terminalCommand} -- sh -c "${fzf} $(/usr/bin/env printf '%q ' "$@") </proc/$$/fd/0 >$ouputFifo" &
      cat <$outputFifo
      rm -- $outputFifo
      ''
      ;

in

{
  options.programs.fzf-window = {
    enable = lib.mkEnableOption "FZF in a new window";

    terminalCommand = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "The terminal command to launch FZF with";
      example = "foot";
    };

  };

  config = lib.mkIf cfg.enable {
    home.packages = [ script ];
  };
}
