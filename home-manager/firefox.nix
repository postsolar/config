{ pkgs, config, ... }:

let

  firefox = pkgs.wrapfirefox pkgs.firefox-devedition-bin-unwrapped {
    
  };

in

{

  home.packages = [
    pkgs.firefox-devedition-bin
    pkgs.floorp
  ];

  # programs.firefox = {
  #   enable = true;
  #   package = firefox;
  #   profiles."default" = {
  #     id = 0;
  #     isDefault = true;
  #     name = "default";
  #     inherit search extensions settings;
  #   };
  # };

  # home.sessionVariables."BROWSER" = l.getExe package;

}

