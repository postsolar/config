default: switch

# Get the hash for a file given a URL
# Will likely fail on non-ASCII URLs.
hash-for url:
    nix hash convert \
        --hash-algo sha256 \
        --from nix32 \
        -- "$(nix-prefetch-url --type sha256 "{{url}}")"

# Get the `fetch` expression given a URL of a Git repo
# Acts via `nurl` which automatically picks the appropriate Nix fetcher and supports GitHub refs.
fetch-git url:
    nix run nixpkgs#nurl -- {{url}}

# Collect garbage
gc:
    # has to be run for every user
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# Build the system and switch to it
switch:
    git add . || :
    sudo nixos-rebuild switch --flake . --verbose -L

# Build the system and switch to it (with NOM)
switch-fancy:
    git add . || :
    nh os switch --ask

# Build home configuration and switch to it
home *hmArgs:
    git add . || :
    home-manager {{hmArgs}} --flake . switch

# Build home configuration and switch to it (with NOM)
home-fancy:
    git add . || :
    nh home switch

# Enter a REPL session with the flake loaded
repl:
    nh os repl

# Select and update flake inputs
update:
    nix flake metadata --json 2>/dev/null \
      | fx .locks.nodes.root.inputs values list \
      | sd 'nixpkgs_\d+' nixpkgs \
      | fzf --multi --bind 'enter:become:echo updating inputs: {+}; nix flake update {+}' \
            --preview 'nix flake metadata {}' \
      || :

# List every dependency (including transitive dependencies) of the current system
list-all-derivations:
    nix-store --query --requisites /run/current-system \
      | cut -d - -f 2- | sort | uniq
