{ ... }:

{
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];
      settings = {
        global = {
          oneshot_timeout = 700;
        };

        main = {
          # xkb config for this works better and i don't use caps as ctrl anyways
          # https://github.com/rvaiya/keyd/issues/940
          # capslock     = "overload(control, esc)";
          leftcontrol  = "oneshot(control)";
          alt          = "oneshot(alt)";
          meta         = "oneshot(meta)";
          shift        = "oneshot(shift)";

          # needs to be set explicitly, otherwise rightcontrol = control
          rightcontrol = "rightcontrol";
        };
      };
    };
  };
}

