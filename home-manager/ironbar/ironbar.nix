{ inputs, system, config, pkgs, lib, ... }:

let

  ironbar =
    # inputs.ironbar.packages.${system}.ironbar.overrideAttrs {
    #   patches = [
    #     (pkgs.fetchurl { url = "%pr link%.diff"; hash = "just hash-for %url%"; })
    #   ];
    # }
    inputs.ironbar.packages.${system}.ironbar
    ;

  stylesheet = 
    pkgs.runCommandLocal "ironbar-styles" {}
      ''
      ${lib.getExe' pkgs.nodePackages.sass "sass"} ${./style.scss} $out
      '';

in

{

  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    package = ironbar;
    style = stylesheet;
    systemd = true;
  };

  xdg.configFile."ironbar/config.yaml".text =
    # yaml
    ''
    name: hyprbar
    position: top
    height: 24
    popup_autohide: true
    ironvar_defaults:
      hyprscrollerMode: "⇒"

    start:
      - type: workspaces
        # TODO: open a PR adding globbing?
        hidden:
          - "special:magic"
          - "special:special"
          - "special:aichat"
          - "special:btm"
      - type: label
        label: "#hyprscrollerMode"
        class: hyprscroller-mode
      - type: custom
        name: bindmode-hints
        bar:
          - type: button
            on_click: "popup:toggle"
            widgets:
              - type: bindmode
        popup:
          - type: label
            label: "#bindmode-hints"

    center:
      - type: music
        marquee:
          enable: true
          max_length: 60
          on_hover: "play"
        marquee_popup_title:
          enable: true
          max_length: 45

    end:
      - type: bluetooth
        format:
          disabled: "󰂲"
          enabled: ""
          connected: " {device_alias}"
          connected_battery: " {device_alias} • {device_battery_percent}%"
        popup:
          max_height:
            devices: 3
      - type: tray
        on_click_left: menu
        on_click_left_double: default
        on_click_right: none
      - type: notifications
      - type: keyboard
        show_caps: false
        show_num: false
        show_scroll: false
        icons:
          layout_map:
            "Carpalx*": "🇺🇸"
            "Estonian*": "🇪🇪"
            "Russian*": "🇷🇺"
      - type: volume
        format: "{icon} {percentage}%"
        max_volume: 150
        icons:
          volume_high: "󰕾"
          volume_medium: "󰖀"
          volume_low: "󰕿"
          muted: "󰝟"
        marquee:
          enable: true
          max_length: 20
          pause_on_hover: true
      - type: clock
        format: "%R"
  '';

}
