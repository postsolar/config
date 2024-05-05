printHelp () {
  local me=${${(%):-%x}:t}
  print "fzf line-wise search: search file contents with fzf
usage:
  $me [opt]
options:
  -d --directory — specify the directory to search in
  -f --file      — specify a file to search in
  -g --glob      — specify a glob to generate files to search in.
                   note that globs which don't include directories are already recursive
  -q --query     — specify initial query
  -l --delimiter — specify the output delimiter
  -h --help      — print help info

flags \`-d\`, \`-f\` and \`-g\` can be applied multiple times
"
}

parseArgs () {
  typeset -ga files globs

  while (( $# )); do
    case $1 in
      -f|--file|-d|--directory)
        files+=($2) ;;
      -g|--glob)
        globs+=($2) ;;
      -q|--query)
        initialQuery=$2 ;;
      -l|--delimiter)
        outputDelimiter=$2 ;;
      -h|--help)
        printHelp; exit 0 ;;
      *)
        printHelp; exit 1 ;;
    esac
    shift 2
  done
  : ${initialQuery=}
  : ${outputDelimiter=:}

  if [[ -z $files && -z $globs ]]; then
    files+=($PWD)
  fi

}

setSettings () {
  rgOpts=(
    --with-filename
    --no-column
    --no-heading
    --color=always
    --colors=match:none
    --field-match-separator ': '
  )

  # no line highlighting for now
  fzfOpts=(
    --delimiter=': '
    --nth=3
    --preview='zat -- {1}'
    --preview-window='+{2}/2'
    --query=$initialQuery
  )
}

# print specific files or directories
printFiles () rg . $rgOpts -- $files

# print files based on glob expressions
printGlobs () rg . $rgOpts -g=${^globs}

printAll () {
  [[ -z $files ]] || printFiles &
  [[ -z $globs ]] || printGlobs
}

parseArgs $@
setSettings

picks=$(printAll | fzf $fzfOpts)
[[ -z $picks ]] || print -l -- $picks | choose -f ': ' -o $outputDelimiter 0..2

