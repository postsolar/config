{ writeZshApplication
, zsh
, libnotify
, foot
, ripgrep
, sd
, fzf
, choose
, mpv
, glow
, imv
}:

writeZshApplication {
  name = "open-clipboard";
  runtimeInputs = [
    zsh
    libnotify
    foot
    ripgrep
    sd
    fzf
    choose
    mpv
    glow
    imv
  ];
  text = builtins.readFile ./open-clipboard.zsh;
}

