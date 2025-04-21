{ config, lib, pkgs, ... }:

let

  inherit (lib.generators) toINI;

  inherit (config) theme;

in

{

  home.packages = [
    pkgs.albert
  ];

  systemd.user.services.albert = {
    Unit = {
      Description = "Albert: a desktop-agnostic launcher";
      Requires = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.albert}/bin/albert";
    };
  };

  xdg.configFile = {
    "albert/config".text = toINI {} {
      General = {
        telemetry = true;
        prioritizePerfectMatch = false;
        memoryDecay = 0.55;
      };
      applications = {
        enabled = true;
        fuzzy = true;
        use_exec = true;
        use_generic_name = true;
        use_keywords = true;
        use_non_localized_name = true;
        terminal = config.home.sessionVariables.TERMINAL;
        trigger = "\"app \"";
      };
      caffeine = {
        enabled = true;
        trigger = "\"inhibit \"";
      };
      calculator_qalculate = {
        enabled = true;
        trigger = "=";
      };
      chromium = {
        enabled = true;
        trigger = "\"bookmark \"";
        fuzzy = true;
      };
      clipboard = {
        enabled = true;
        trigger = "\". \"";
        persistent = true;
      };
      datetime = {
        enabled = true;
        global_handler_enabled = false;
        show_date_on_empty_query = true;
        trigger = "dt";
      };
      files = {
        enabled = true;
        fuzzy = true;
        fs_browsers_match_case_sensitive = false;
        trigger = "\"file \"";
      };
      python.enabled = true;
      "python.emoji" = {
        enabled = true;
        global_handler_enabled = false;
        use_derived = false;
        fuzzy = true;
      };
      # can't install deps for some reason
      # "python.unit_converter" = {
      #   enabled = true;
      # };
      system = {
        enabled = true;
        fuzzy = true;
      };
      snippets = {
        enabled = true;
        fuzzy = true;
        trigger = "\"snippet \"";
      };
      triggers.trigger = "\"trigger \"";
      urlhandler.enabled = true;
      websearch.enabled = true;
      widgetsboxmodel = {
        alwaysOnTop = true;
        clearOnHide = true;
        clientShadow = false;
        lightTheme = "Ink";
        darkTheme = "Ink";
        displayScrollbar = true;
        followCursor = true;
        hideOnFocusLoss = false;
        historySearch = true;
        itemCount = 8;
        quitOnClose = false;
        showCentered = true;
        systemShadow = false;
      };
    };

    # "albert/snippets/Sample Snippet.txt".text = "";

    # icons are just much easier and less tedious to set manually
    "albert/websearch/engines.json".source = pkgs.writers.writeJSON "albert webengines config" [
      {
        name = "ChatGPT";
        trigger = "@gpt";
        url = "https://chat.openai.com/?q=%s";
      }
      {
        name = "Google";
        trigger = "@gg";
        url = "https://www.google.com/search?q=%s";
      }
      {
        name = "Home Manager options";
        trigger = "@hmopts";
        url = "https://home-manager-options.extranix.com/?release=master&query=%s";
      }
      {
        name = "Nix options";
        trigger = "@nixopts";
        url = "https://search.nixos.org/options?channel=unstable&query=%s";
      }
      {
        name = "Nix packages";
        trigger = "@nixpkgs";
        url = "https://search.nixos.org/packages?channel=unstable&query=%s";
      }
      {
        name = "Noogle";
        trigger = "@noogle";
        url = "https://noogle.dev/q?term=%s";
      }
      {
        name = "Sõnaveeb";
        trigger = "@sõnaveeb";
        url = "https://sonaveeb.ee/search/unif/dlall/dsall/%s/1/est";
      }
      {
        name = "Wikipedia (en)";
        trigger = "@wiki";
        url = "https://en.wikipedia.org/w/index.php?search=%s";
      }
      {
        name = "YouTube";
        trigger = "@yt";
        url = "https://www.youtube.com/results?search_query=%s";
      }
    ];
  };

  # Symlinks are not supported, add it manually
  home.activation.copyAlbertThemes =
    let
      themeInk = import ./themes/Ink.nix { inherit theme lib; } |> pkgs.writeText "Albert theme Ink.qss";
      themeTargetDir = "${config.xdg.dataHome}/albert/widgetsboxmodel/themes/";
    in
      lib.hm.dag.entryAfter [ "writeBoundary" ]
        ''
        run cp -f $VERBOSE_ARG -- "${themeInk}" "${themeTargetDir}/Ink.qss"
        '';

}

