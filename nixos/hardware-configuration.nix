{ config, lib, pkgs, ... }:

{

  imports = [
    ./nvidia.nix
  ];

  # think it forces me to build every possible driver under the sun
  # hardware.enableAllFirmware = true;
  # this one is more nuanced ig
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "video=eDP-1:1600x900" "nvidia_drm.modeset=1" ];
  boot.extraModulePackages = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 150;
  };

  services.earlyoom = {
    enable = true;
    killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
      notify-send "Process killed" "$EARLYOOM_NAME (pid $EARLYOOM_PID)"
    '';
    enableNotifications = true;
    freeMemKillThreshold = 10;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6b86347c-cdf1-4caa-b12a-0f0e4ceffcc7";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D35B-7FAC";
      fsType = "vfat";
    };

  fileSystems."/data" =
    { device = "/dev/sda9";
      fsType = "ext4";
    };

  fileSystems."/arch" =
    { device = "/dev/sda10";
      fsType = "ext4";
    };

  swapDevices = [];

  networking.useDHCP = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = true;

}

