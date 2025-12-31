default: home-fancy

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
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# Build home configuration and switch to it
home:
    git add . || :
    home-manager switch --flake . -L --verbose

# Build home configuration and switch to it (agent-friendly output)
home-agent:
    git add . || :
    home-manager switch --flake . -L

# Build home configuration and switch to it (with NOM)
home-fancy:
    git add . || :
    nh home switch .

# Select and update flake inputs
update:
    nix flake metadata --json 2>/dev/null \
      | fx .locks.nodes.root.inputs values list \
      | sd 'nixpkgs_\d+' nixpkgs \
      | fzf --multi --bind 'enter:become:echo updating inputs: {+}; nix flake update {+}' \
            --preview 'nix flake metadata {}' \
      || :
