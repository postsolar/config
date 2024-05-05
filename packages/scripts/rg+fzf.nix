{ writeZshApplication, ripgrep, fzf, choose }:

writeZshApplication {
  name = "rg+fzf";
  text = builtins.readFile ./rg+fzf.zsh;
  runtimeInputs = [ ripgrep fzf choose ];
}

