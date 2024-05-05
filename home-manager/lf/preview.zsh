displayEmpty      () print -P -- "%S$1: empty%s"
displayText       () zat -- $1
displayImage      () chafa -f sixel -s $width'x'$height --polite on -- $1
displayVideo      () file -Lp -- $1
displayExecutable () file -Lp -- $1
displayBinary     () file -Lp -- $1

display () \
  case ${ file -Likbp -- $1 } in
    *inode/x-empty*)            displayEmpty $1 ;;
    *charset=(*ascii|utf-8)*|)  displayText $1 ;;
    *text/plain*)               displayText $1 ;;
    *image*)                    displayImage $1 ;;
    *video*)                    displayVideo $1 ;;
    *application/x-executable*) displayExecutable $1 ;;
    *charset=binary*)           displayBinary $1 ;;
    *)                          return 1 ;;
  esac

main () {
  filename=$1
  width=$2
  height=$3
  # horzPos=$4
  # vertPos=$5
  display $filename
}

main $@

