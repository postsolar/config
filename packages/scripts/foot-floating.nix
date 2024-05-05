{ writeZshApplication, foot, scripts, fx }:

writeZshApplication {
  name = "foot-floating";
  text = builtins.readFile ./foot-floating.zsh;
  runtimeInputs = [
    foot
    scripts.hyprland-center-window
    fx
  ];
}

