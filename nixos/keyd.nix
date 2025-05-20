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

