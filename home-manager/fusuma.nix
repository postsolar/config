{ ... }:

{

  xdg.configFile."fusuma/config.yml".text =
    /* yaml */
    ''
    swipe:
      3:
        up:
          command: zsh -c "hyprctl dispatch hyprexpo:expo toggle"

    threshold:
      swipe: 0.8
    '';

}

