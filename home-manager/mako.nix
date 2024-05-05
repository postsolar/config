{ config, lib, pkgs, ... }:

let
  chooseAction = pkgs.writeZshApplication {
    name = "choose-notification-action.zsh";
    text = # zsh
      ''
      #! /usr/bin/env zsh
      < /dev/stdin > /tmp/notification-action-choices
      foot-floating -a '-float -center -wh20' -- 'gum choose < /tmp/notification-action-choices'
      '';
    runtimeInputs = [ pkgs.scripts.foot-floating pkgs.gum ];
  };
in

{
  services.mako =

    lib.attrsets.filterAttrsRecursive (_: v: v != null)
    {

      enable = true;

      extraConfig =
        ''
        text-alignment=center

        on-button-right=exec makoctl menu -n "$id" ${chooseAction}

        [actionable=true]
        format=<b>%s</b>\n%b\n<b>[Actions available]</b>
        ''
        ;

      defaultTimeout = 15000;
      maxVisible = -1;

      font = lib.mapNullable (f: f + " 12px") config.theme.monospaceFont;

      backgroundColor = (config.theme.colors.background or "#000000") + "88";
      textColor       = (config.theme.colors.foreground or "#ffffff") + "ff";
      borderColor     = (config.theme.colors.foreground or "#ffffff") + "ff";
      progressColor   = (config.theme.colors.foreground or "#ffffff") + "ff";

      borderSize = 1;
      borderRadius = 2;

      icons = true;

    };
}

