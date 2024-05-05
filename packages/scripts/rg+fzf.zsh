printHelp () {
  local me=${${(%):-%x}:t}
  print "livegrep: rg + fzf. find files and open them in \$EDITOR.
usage:
  $me [opt]
options:
  -d --directory — specify the directory to search in
  -e --regex     — specify initial regex query
  -l --delimiter — specify the output delimiter
  -h --help      — print help info
controls:
  a-t → toggle search mode. initial search mode is regex with ripgrep,
        its results can be narrowed down by switching to files with fzf mode.
"
}

parseArgs () {
  while (( $# )); do
    case $1 in
      -d|--directory)
        directory=$2 ;;
      -e|--regex)
        initialQuery=$2 ;;
      -l|--delimiter)
        outputDelimiter=$2 ;;
      -h|--help)
        printHelp; exit ;;
      *)
        printHelp; exit 1 ;;
    esac
    shift 2
  done
  : ${directory:=$PWD}
  : ${initialQuery:=}
}

setSettings() {

  export rgFzfTmpDir=$(mktemp -d)

  if [[ -v commands[zat] ]]; then
    rgPreview='zat -- {1} | nl -ba'
    fzfPreview='zat -- {1}'
  else
    rgPreview='nl -ba -- {1}'
    fzfPreview='cat -- {1}'
  fi

  # \u2236, distinct from plain `:`
  internalDelimiter='∶'
  : ${outputDelimiter:=':'}
  rgPrompt=' rg → '
  fzfPrompt=' fzf → '
  previewWindow='up,60%,border-bottom,+{2}/2'

  rgArgs=(
    --no-heading
    --column
    --line-number
    --field-match-separator=$internalDelimiter
    --color=always
  )

  fzfArgs=(
    --ansi
    --disabled 
    --multi
    --delimiter=$internalDelimiter
    --nth=1
    "--query=$initialQuery"
    "--preview=$rgPreview"
    "--preview-window=$previewWindow"
    "--bind=start:reload(rg $rgArgs -- {q})"
    "--bind=change:reload(sleep 0.2; rg $rgArgs -- {q})"
    '--bind=alt-t:transform:[[ ! {fzf:prompt} =~ rg ]] &&
      print "rebind(change)+change-prompt('$rgPrompt')+disable-search+transform-query:print -- \{q} > $rgFzfTmpDir/f; cat $rgFzfTmpDir/rg+fzf-r" ||
      print "unbind(change)+change-prompt('$fzfPrompt')+enable-search+transform-query:print -- \{q} > $rgFzfTmpDir/r; cat $rgFzfTmpDir/rg+fzf-f"'
    "--prompt=$rgPrompt"
  )

  chooseArgs=(
    -f $internalDelimiter
    -o $outputDelimiter
    0..3
  )

}

cleanup () {
  rm -rf $rgFzfTmpDir
}

main () {
  parseArgs $@
  cd -- $directory
  setSettings
  : | fzf $fzfArgs | choose $chooseArgs
  cleanup
}

main $@

