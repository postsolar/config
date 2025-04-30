{ lib, config, ... }:

let
  inherit (config.theme) colors;
  unhashAll = lib.mapAttrs <| lib.const <| lib.strings.removePrefix "#";
in

{
  main = {
    prompt = "\"»  \"";
    show-actions = true;
    font = builtins.head config.theme.fonts.sansSerif;
    width = 25;
    use-bold = true;
    horizontal-pad = 15;
    vertical-pad = 15;
    inner-pad = 10;
    fields = "filename,name,generic,exec,categories,keywords";
    keyboard-focus = "on-demand";
    # no-exit-on-keyboard-focus-loss = false;
  };

  colors = unhashAll {
    background = colors.background + "da";
    text = colors.text + "ff";
    prompt = colors.text + "55";
    placeholder = colors.text + "55";
    input = "f08080ff";
    match = "dc143cff";
    selection = "5a435cff";
    selection-text = colors.text + "ff";
    selection-match = "ff4500ff";
    border = colors.border + "ff";
  };

  border = {
    width = 4;
    radius = 0;
  };

  key-bindings = {
    cursor-left-word = "Control+Left Mod1+Left";
    cursor-right-word = "Control+Right Mod1+Right";
  };
}

