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

# change directory into one of child directories using fzf
# function fzfcd -w fzf
#   builtin cd -- (fd -HL -td . | fzf --scheme=path --tiebreak=length --height=50% +m)
# end

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

# output which files block home-manager
function what-files-block-hm
  set journalctlArgs --reverse --unit home-manager-alice.service --since '60m ago'
  set rgArgs --no-line-number --no-column --color never --no-multiline-dotall
  set re "existing file \'(?<f1>.+?)\' is in the way of \'(?<f2>.+?)\'(?:, )?(?<extra>.+)?"
  set replace "$(set_color blue)\$f1$(set_color reset) -> $(set_color red)\$f2$(set_color reset) $(set_color -di)// \$extra$(set_color reset)"

  # i think they changed the format recently
  set re2 "Existing file \'(?<existing>.*)\' would be clobbered by backing up \'(?<new>)\'"
  set replace2 "$(set_color blue)\$existing$(set_color reset) -> $(set_color red)\$new$(set_color reset)"

  journalctl $journalctlArgs | rg $rgArgs $re -or $replace \
  || journalctl $journalctlArgs | rg $rgArgs $re2 -or $replace2
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

# download soundcloud/youtube tracks and upload them to a telegram channel
# TODO not good at doing SC playlists : filenames aren't numbered and tdl uploads them 1 per message, in random order
# also tdl fucks up telegram-desktop connection
# need to polish it a lot
function scdl-tgup
  set chat 2437712025
  set links $argv
  set tmp (mktemp --tmpdir --directory scdl-tgup.XXXX)

  for l in $links
    if string match -rq 'youtu\.?be' $l
      # ytmdl --output-dir $tmp --url $l || return 1
      yt-dlp -t mp3 -P $tmp $l
    else
      scdl --addtofile \
           --onlymp3 \
           --overwrite \
           --path $tmp \
           -l $l \
        || return 1
    end
  end

  set tdlArgs
  for f in $tmp/*
    set tdlArgs $tdlArgs -p $f
  end

  tdl up -c $chat $tdlArgs
end

function _aichat_fish
  set -l _old (commandline)
  if test -n $_old
    echo -n "⌛"
    commandline -f repaint
    commandline -- (aichat -c -e $_old)
  end
end

