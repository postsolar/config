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

  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia_drm.modeset=1" ];

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

  environment.sessionVariables = {
    # makes firefox crash?
    # GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DRM_DEVICE = "/dev/dri/renderD129";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_backend = "vulkan";
    DRI_PRIME = "pci-0000_03_00_0";
    NVD_BACKEND = "direct";
    NVD_BACKEND__GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # put everything onto nvidia card
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };

}

