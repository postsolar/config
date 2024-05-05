{ writeZshApplication, ripgrep, fzf, choose, ... }:

writeZshApplication {
  name = "fzf-linewise";
  text = builtins.readFile ./fzf-linewise.zsh;
  runtimeInputs = [ ripgrep fzf choose ];
}

