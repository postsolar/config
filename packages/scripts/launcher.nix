{ writeZshApplication, fzf, ... }:

writeZshApplication {
  name = "launcher";
  runtimeInputs = [ fzf ];
  text =
    ''
    print -l -- ''${(ko)commands} \
      | fzf --with-shell='zsh -c' --bind='enter:become:setsid -f $(if [[ -z {} ]]; then echo {q}; else echo {}; fi)'
    '';
}

