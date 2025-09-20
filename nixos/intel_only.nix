# intel-only setup, don't use the nvidia card

{ inputs, config, pkgs, lib, ...  }:

let
  # This pins the mesa version to what is specified by Hyprland
  openglDriver = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa;
in

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

    package = openglDriver;

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
