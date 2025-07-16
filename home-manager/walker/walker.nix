{ inputs, lib, pkgs, system, ... }:

let
  walker = inputs.walker.packages.${system}.walker;
in

{
  home.packages = [
    walker
    # for `calc` module
    pkgs.libqalculate
  ];

  systemd.user.services.walker = {
    Unit.Description = "Walker multi-purpose launcher gapplication service";
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${lib.getExe walker} --gapplication-service";
    # https://github.com/abenz1267/walker/issues/258
    Service.Environment = [ "GTK_IM_MODULE=fcitx" ];
    Service.Restart = "on-failure";
  };

  xdg.configFile."walker/config.toml".text =
    # kept in the config are, for the most part, non-default things and some examples
    # ref: https://github.com/abenz1267/walker/blob/master/internal/config/config.default.toml
    /* toml */ ''
    theme = "black"
    app_launch_prefix = "systemd-run --user "
    hotreload_theme = true
    disable_click_to_close = true

    [keys]

    [keys.activation_modifiers]

    [keys.ai]

    [events]

    [list]
    placeholder = "No results"

    [search]
    # e.g. `fish#-ic bb` or `firefox#--private-window`
    argument_delimiter = "#"
    placeholder = "Search…"

    [activation_mode]
    labels = "qwydsazxc"

    [builtins.hyprland_keybinds]
    weight = 5

    [builtins.applications]
    weight = 5

    [builtins.applications.actions]

    # bookmarks are added manually, see example below
    [builtins.bookmarks]
    weight = 5

    [[builtins.bookmarks.entries]]
    label = "Walker"
    url = "https://github.com/abenz1267/walker"
    keywords = ["walker", "github"]

    [builtins.xdph_picker]
    # the default is `xdphpicker` for some reason, not matching conf name
    name = "xdph_picker"

    [builtins.ai]
    # todo: set up gemini provider
    # sadly the only documentation is source code
    hidden = true
    weight = 5
    placeholder = "AI"
    name = "ai"
    icon = "help-browser"
    switcher_only = true
    show_sub_when_single = true

    [[builtins.ai.anthropic.prompts]]
    model = "claude-3-7-sonnet-20250219"
    temperature = 1
    max_tokens = 1_000
    label = "General Assistant"
    prompt = "You are a helpful general assistant. Keep your answers short and precise."

    [builtins.calc]
    require_number = false
    min_chars = 0
    weight = 5

    [builtins.windows]
    weight = 6

    [builtins.clipboard]

    [builtins.commands]

    [builtins.custom_commands]

    [builtins.emojis]

    [builtins.symbols]

    # finder is mostly broken, not sure why
    [builtins.finder]
    use_fd = true
    fd_flags = "--ignore-vcs --type file --type directory"
    cmd_alt = "xdg-open $(dirname ~/%RESULT%)"
    weight = 5

    [builtins.runner]
    eager_loading = true
    weight = 5

    [builtins.ssh]
    weight = 5

    [builtins.switcher]

    [builtins.websearch]
    keep_selection = true
    weight = 5

    [[builtins.websearch.entries]]
    name = "Google"
    url = "https://www.google.com/search?q=%TERM%"

    [builtins.dmenu]
    hidden = true
    weight = 5

    [builtins.translation]
    delay = 1000
    '';

    xdg.configFile."walker/themes/black.css".source = ./black.css;
    xdg.configFile."walker/themes/black.toml".source = ./black.toml;
}

