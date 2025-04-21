{ pkgs, config, inputs, ... }:

let

  nvidiaDriver = config.boot.kernelPackages.nvidiaPackages.beta;

  # This pins the mesa version to what is specified by Hyprland
  openglDriver = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa;

in

{

  environment.systemPackages = [
    pkgs.nvtopPackages.full
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      package = openglDriver;
      extraPackages = [
        pkgs.vaapiVdpau
        pkgs.libvdpau-va-gl
        pkgs.nvidia-vaapi-driver
        pkgs.vaapi-intel-hybrid
        pkgs.egl-wayland
      ];
    };

    nvidia-container-toolkit = {
      enable = true;
    };

    nvidia = {
      package        = nvidiaDriver;
      open           = false;
      nvidiaSettings = true;

      modesetting.enable = true;
      nvidiaPersistenced = true;

      # needed for apps to not have issues after waking up from suspend
      # ref: https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend
      # ref: https://github.com/prasanthrangan/hyprdots/issues/640
      powerManagement.enable = true;

      powerManagement.finegrained = false;

      prime = {
        offload.enable           = true;
        offload.enableOffloadCmd = true;
        # sync.enable              = true;
        intelBusId               = "PCI:0:2:0";
        nvidiaBusId              = "PCI:3:0:0";
      };
    };

  };

}

