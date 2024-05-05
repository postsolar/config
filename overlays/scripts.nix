final: prev:

let inherit (final.pkgs) callPackage; in

{
  scripts = {

    hyprland-center-window = callPackage
      ../packages/scripts/hyprland-center-window.nix {};

    foot-floating = callPackage
      ../packages/scripts/foot-floating.nix {};

    launcher = callPackage
      ../packages/scripts/launcher.nix {};

    unicode-picker = callPackage
      ../packages/scripts/unicode-picker.nix {};

    "rg+fzf" = callPackage
      ../packages/scripts/rg+fzf.nix {};

    fzf-linewise = callPackage
      ../packages/scripts/fzf-linewise.nix {};

    random-wallpaper = callPackage
      ../packages/scripts/random-wallpaper.nix {};

    screenshot = callPackage
      ../packages/scripts/screenshot.nix {};

  };
}

