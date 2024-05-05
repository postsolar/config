help='launch a floating foot window in Hyprland while capturing the output of executed commands
  arguments:
    --              ⇒ marks the beginning of the command to be executed
    --stdin         ⇒ makes commands be read from stdin
    --output        ⇒ specifies the file to write output to (default: stdout)
    --center        ⇒ makes the window floating and centered across the desktop
    --center-active ⇒ makes the window floating and centered across the current active window
    --active-ratios ⇒ (with --center or --center-active) width and height ratios (in percentages) relative to the current active window, e.g. `--active-ratios 70 70`. if unspecified, left to WM/foot.
    --shell         ⇒ specifies the shell to use. default is `/usr/bin/env sh`. passed argument gets word-split so quote it if necessary
    --foot          ⇒ foot command (default: `footclient -E`)
    -h --help       ⇒ print usage help

  everything else gets passed to the foot command

  flags `--center` and `--center-active` set window class, so if additional `-a` is
  used as extra arguments, it will override previously set classes
'

# print out the usage information
print-help () print $help

# print out an error message, the usage information and exit
# with status code 1
error () {
  >&2 print -rl -- $1
  >&2 print-help
  exit 1
}

# set default values for some options
set-defaults () {
  cmd=""
  outFile=/dev/stdout
  position=none
  foot=(footclient -E)
  footArgs=()
  shell=(/usr/bin/env sh)
}

# parse arguments and set/override relevant options
parse-args () {
  while (( $# )); do
    case $1 in
      --)
        shift
        cmd=$*
        break
        ;;
      --stdin)
        cmd=${ cat }
        ;;
      --output)
        outFile=$2
        shift
        ;;
      --center)
        position=center
        ;;
      --center-active)
        position=center-active
        ;;
      --active-ratios)
        if (( $2 )) && (( $3 )); then
          relativeHeight=$2
          relativeWidth=$3
        else
          error "Invalid values for $1: '$2' and '$3'"
        fi
        shift 2
        ;;
      --shell)
        shell=$2
        shift
        ;;
      *)
        footArgs+=($1)
        ;;
    esac
    shift
  done
}

# create a fifo file and return its full path
setup-fifo () {
  procFifo=${TMP_DIR:-/tmp}/foot-fifo-$(uuidgen)
  mkfifo $procFifo
  print $procFifo
}

# set foot's geometry argument based on height and width passed
setup-geometry () {
  h=$1
  w=$2

  size=${
    hyprctl -j activewindow \
      | fx .size \
           '.map((x, i) => x / 100 * (i === 0 ? '$w' : '$h'))' \
           '.map(Math.floor)' \
           '.join("x")'
  }

  footArgs+=(-w $size)
}

# modify foot arguments and the command based on whether we want to:
#   a) center the window
#   b) center the window across another window
#   c) neither
set-positioning-command () {
  case $1 in
    center)
      footArgs+=(-a "-float -center")
      ;;

    center-active)
      cmd="
        hyprland-center-window --across ${ hyprctl -j activewindow | fx .address } > /dev/null
        $cmd"
      footArgs+=(-a "-float")
      ;;
  esac
}

main () {
  set-defaults
  parse-args $@
  fifo=${ setup-fifo }
  set-positioning-command $position

  if [[ -v relativeHeight && -v relativeWidth ]]; then
    setup-geometry $relativeHeight $relativeWidth
  fi

  $foot $footArgs $=shell -c "
    { $cmd
    } | tee $fifo
    " &

  cat < $fifo > $outFile
  rm $fifo
}

main $@

