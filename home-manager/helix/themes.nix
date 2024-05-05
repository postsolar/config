{ ... }:

{
  xdg.configFile."helix/runtime/themes/amberwood-fixed.toml".text =
    builtins.readFile ./themes/amberwood-fixed.toml;
}

