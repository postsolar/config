# intel-only setup, don't use the nvidia card

{ inputs, config, pkgs, lib, ...  }:

{

  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidiafb"
    "nvidia-drm"
    "nvidia-uvm"
    "nvidia-modeset"
    "nouveau"
  ];

  environment.systemPackages = [
    pkgs.nvtopPackages.full
  ];

  hardware.graphics = {
    enable = true;

    extraPackages = [
      pkgs.egl-wayland
      pkgs.intel-compute-runtime-legacy1
      pkgs.intel-vaapi-driver
      pkgs.libvdpau-va-gl
      pkgs.vaapi-intel-hybrid
      pkgs.vaapiVdpau
    ];
  };

}

