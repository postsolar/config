{ config, lib, pkgs, ... }:

let

  fzf = lib.getExe config.programs.fzf.package;

  terminal = "kitty -1 --title 'fzf-picker'";

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
      ${terminal} -- sh -c "${fzf} $(/usr/bin/env printf '%q ' "$@") </proc/$$/fd/0 >$outputFifo" &
      cat <$outputFifo
      rm -- $outputFifo
      ''
      ;

in

{
  home.packages = [ script ];
}
