# it got a bit messy so probably needs a full reset,
# also hyprland env vars should be given a review/reset
#
# ref: https://github.com/TLATER/dotfiles/tree/master/nixos-modules/nvidia
# ref: https://discourse.nixos.org/t/nvidia-open-breaks-hardware-acceleration/58770/
# (and anything on nixos discourse mentioning nvidia)

{ pkgs, config, inputs, ... }:

let

  nvidiaDriver = config.boot.kernelPackages.nvidiaPackages.stable;

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
        pkgs.vaapi-intel-hybrid
        pkgs.egl-wayland
        pkgs.intel-compute-runtime-legacy1
        pkgs.intel-vaapi-driver
        pkgs.nvidia-vaapi-driver
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

