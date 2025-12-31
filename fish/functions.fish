# ~ aliases

function sudo -w sudo; command sudo -E $argv; end

function e  -w eza; eza --icons always --color always --reverse --hyperlink --no-quotes --git --all --group-directories-first $argv; end
function e1 -w eza; e -1 $argv; end
function ee -w eza; e -l $argv; end
function et -w eza; e -T --git-ignore $argv; end

function bb -w btm; command btm $argv; end
function y -w yazi; command yazi $argv; end

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

# print arguments separated by a newline character, with a trailing newline
function lines
  printf %s\n $argv
end

# a `nix shell` wrapper which removes the need for the `nixpkgs#` prefix
function ns -w 'nix shell'
  command nix shell --impure nixpkgs#{$argv}
end

# unlock a git-crypt-locked repo assuming the key is copied to clipboard
function unlock-git-crypt -a paste
  git-crypt unlock (printf %s $paste | base64 --decode | psub)
end

