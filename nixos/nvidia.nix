{ pkgs, config, inputs, ... }:

let

  driver = config.boot.kernelPackages.nvidiaPackages.beta;

in

{

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
      pkgs.nvidia-vaapi-driver
      pkgs.vaapi-intel-hybrid
      pkgs.egl-wayland
    ];
  };

  # This pins the mesa version to what is specified by Hyprland
  hardware.opengl.package =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;

    powerManagement.enable      = false;
    powerManagement.finegrained = false;

    open           = false;
    nvidiaSettings = false;
    package        = driver;

    prime = {
      offload.enable           = true;
      offload.enableOffloadCmd = true;
      # sync.enable              = true;
      intelBusId               = "PCI:0:2:0";
      nvidiaBusId              = "PCI:3:0:0";
    };

  };

}

