{ writeZshApplication, fx }:

writeZshApplication {
  name = "hyprland-center-window";
  text = builtins.readFile ./hyprland-center-window.zsh;
  runtimeInputs = [ fx ];
}

