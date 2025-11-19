# ~ aliases

function sudo -w sudo; command sudo -E $argv; end
function trash -w "gio trash"; gio trash $argv; end

function e  -w eza; eza --icons always --color always --reverse --hyperlink --no-quotes --git --all --group-directories-first $argv; end
function e1 -w eza; e -1 $argv; end
function ee -w eza; e -l $argv; end
function et -w eza; e -T --git-ignore $argv; end

function bb -w btm; command btm $argv; end
function y -w yazi; command yazi $argv; end
function ai -w aichat; command aichat $argv; end

function hx -w hx
  if count $argv &>/dev/null
    command hx $argv
  else if not isatty stdin
    command hx $argv
  else
    command hx .
  end
end

# ~ functions

# open a manpage formatted into markdown in $PAGER via `glow`
#
# slightly better output than `man -H`
# can also do `| pandoc -f man -t html --standalone`
function man -w man -a q
  set pages (command man -a -w $q)
  count $pages >/dev/null || return 1
  for page in $pages
    if test (path extension $page) = .gz
      zcat -- $page
    else
      cat -- $page
    end
  end | pandoc --from man --to commonmark | glow -p
end

# open a manpage using arch man pages
function webman -w man
  xdg-open https://man.archlinux.org/search?lang=en&q={$argv}
end

# print arguments separated by a newline character, with a trailing newline
function lines
  printf %s\n $argv
end

# print a selection of named CSS colors
function css-colors
  for col in (unbuffer pastel list | gum filter --no-limit --no-strip-ansi)
    echo $col | pastel paint -o $col (pastel textcolor $col)
  end
end

# print a selection of named CSS colors and their hex, rgb, hsl values,
# as well as the names of colors most similar to them
function css-colors+
  unbuffer pastel list \
    | gum filter --no-limit --no-strip-ansi \
    | xargs pastel color
end

# create output with `hx`
#
# usecases:
#   - create a prompt for aichat without quoting hell, e.g. `hx-out | aichat` or `aichat "$(hx-out)"`
function hx-out
  set -x tmp "$(mktemp --tmpdir hx-out.XXXX)"

  # if stdin is present use it to pre-fill the temp file
  isatty stdin || cat >$tmp

  handlr launch x-scheme-handler/terminal -- sh -c '
    hx -- "$tmp"
    kill -s CONT '$fish_pid

  kill -s STOP $fish_pid

  cat -- $tmp
  rm -f -- $tmp
end

# create a temporary file and open it with `hx`
function hx-temp -a suffix
  set suffix "$(test -n "$suffix" && lines "_$suffix")"
  set tmp "$(mktemp --tmpdir --suffix "$suffix")"
  hx -- $tmp
  rm -- $tmp
end

# a `nix shell` wrapper which removes the need for the `nixpkgs#` prefix
function ns -w 'nix shell'
  command nix shell --impure nixpkgs#{$argv}
end

# write a commit message with aichat
function ai-commit
  set prompt "write a commit message based on this diff"
  begin
    date +%c\n | string replace '   ' ' '
    git diff --staged --no-ext-diff | aichat -c -S $prompt
  end | git commit -e -F -
end

# unlock a git-crypt-locked repo assuming the key is copied to clipboard
function unlock-git-crypt
  git-crypt unlock (wl-paste -t text/plain | base64 --decode | psub)
end

# print hyprland IPC events
function hyprevents
  # socat over nc because the latter doesn't work when an interactive shell puts it into background
  socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
end

function _aichat_fish
  set -l _old (commandline)
  if test -n $_old
    echo -n "⌛"
    commandline -f repaint
    commandline -- (aichat -c -e $_old)
  end
end

