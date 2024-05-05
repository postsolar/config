{ lib
, writeZshApplication
, swww
, ripgrep
, fd
# a function (attrset → attrset) to override default args to swww
, swwwArgsOverrides ? (x: x)
# directory for wallpapers to look into, overridable with $WALLPAPERS_DIR
, wpDir ? "/data/Pictures"
, ...
}:

let
  defaultArgs = {
    "--transition-type" = "wave";
    "--transition-duration" = "4";
    "--transition-fps" = "120";
    "--transition-wave" = "30,30";
    "--transition-bezier" = "0.98,0.29,0.45,0.94";
    "--transition-angle" = "\${ shuf -i 0-360 -n 1 }";
    "--transition-step" = "30";
  };
  finalArgs =
    builtins.concatStringsSep "\n  "
      (lib.attrsets.mapAttrsToList (k: v: "${k} ${v}")
        (swwwArgsOverrides defaultArgs));
in

writeZshApplication {
  name = "random-wallpaper";
  runtimeInputs = [ swww ripgrep fd ];
  text =
    ''
    wpDir=''${WALLPAPERS_DIR-${wpDir}}
    typeset -UA swwwArgs=(
      ${finalArgs}
    )
    curr=''${''${ swww query | rg -N --no-column -or '$1' 'image: (.+)' || print none }:t}
    next=''${ fd . -0 --exclude=$curr -tf $wpDir | shuf -z -n 1 }
    swww img ''${(kv)swwwArgs} -- $next
    '';
}

