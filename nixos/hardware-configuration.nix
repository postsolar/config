{ config, lib, pkgs, ... }:

{
  imports = [
    ./nvidia.nix
  ];

  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia_drm.modeset=1" ];
  boot.extraModulePackages = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  environment.systemPackages = [ pkgs.bluetui pkgs.fbset ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/081352c6-6f25-4607-87e7-069c55da61f7";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5A0E-AA20";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
    "/data" = {
      device = "/dev/sda9";
      fsType = "ext4";
    };
  };

  swapDevices = [];

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 150;
  };

  services.earlyoom = {
    enable = true;
    killHook = pkgs.writeShellScript "earlyoom-killhook" ''
      notify-send "Process killed" "$EARLYOOM_NAME ($EARLYOOM_PID)"
    '';
    enableNotifications = true;
    freeMemKillThreshold = 10;
  };

  services.libinput.enable = true;
  services.thermald.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
