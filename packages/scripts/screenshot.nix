{ writeZshApplication
, wl-clipboard
, flameshot
, yad
, ...
}:

writeZshApplication {
  name = "screenshot";
  runtimeInputs = [ wl-clipboard flameshot yad ];
  text = builtins.readFile ./screenshot.zsh;
}

