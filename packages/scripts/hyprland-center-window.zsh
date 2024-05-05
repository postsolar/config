help='center a window, either across the workspace (default) or across another window
  arguments:
    -w --window ⇒ the target window address, address of the window to center (defaults to active floating window)
    -a --across ⇒ address of the window across which to center the target window
  window addresses come unquoted, use `jq -r` instead of `jq` (or use `fx`)
'

parse-args () {
  while (( $# )); do
    case $1 in
      -w|--window) targetWindow=$2 ;;
      -a|--across) destinationWindow=$2 ;;
      -h|--help) print $help; exit ;;
      *)
        >&2 print "unrecognized argument: $1"
        >&2 print $help
        exit 1
        ;;
    esac
    shift 2
  done
}

window-at-and-size () {
  clients=$1
  window=$2
  into=$3
  fxQuery=(
    ".find(x => x.address == '$window')"
    'x => [...x.at, ...x.size]'
    list
  )
  set -A $into ${(f)${ fx $^fxQuery <<< $clients }}
}

main () {
  parse-args $@

  : ${targetWindow:=${ hyprctl -j activewindow | fx .address }}

  if [[ -n ${destinationWindow-} ]]; then
    clients=${ hyprctl -j clients }

    window-at-and-size $clients $destinationWindow destDims
    destX=${destDims[1]} destY=${destDims[2]}
    destWidth=${destDims[3]}
    destHeight=${destDims[4]}

    window-at-and-size $clients $targetWindow targetDims
    targetWidth=${targetDims[3]}
    targetHeight=${targetDims[4]}

    targetNewX=${ printf '%.0f' $(( ((destWidth - targetWidth) / 2) + destX )) }
    targetNewY=${ printf '%.0f' $(( ((destHeight - targetHeight) / 2) + destY )) }

    hyprctl dispatch movewindowpixel "exact $targetNewX $targetNewY,address:$targetWindow" > /dev/null

  elif hyprctl dispatch focuswindow "address:$targetWindow"; then
    hyprctl dispatch centerwindow

  fi
}

main $@ > /dev/null

