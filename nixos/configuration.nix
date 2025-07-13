{ inputs, config, pkgs, lib, ... }:

{

  system.stateVersion = "24.11";

  imports =
    [
      ./hardware-configuration.nix
      ./keyd.nix
      ./xkb.nix
      ./dotool.nix
    ];

  # ~ keyboard

  console.useXkbConfig = true;
  services.xserver.xkb.layout = "carpalx-qwyrfm";

  # ibus is basically unusable with hyprland atm anyways, so disabling it for now
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [
  #     uniemoji
  #     typing-booster
  #   ];
  # };

  # ~ wayland

  security.polkit.enable = true;

  # ~ pipewire

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ~ systemd-boot EFI boot loader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ~ networks

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
  };

  # ~ localization

  time.timeZone = "Europe/Tallinn";

  i18n = {
    defaultLocale = "et_EE.UTF-8";

    supportedLocales = [
      "C.UTF-8/UTF-8"
      "et_EE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_NUMERIC="et_EE.UTF-8";
      LC_TIME="et_EE.UTF-8";
      LC_COLLATE="et_EE.UTF-8";
      LC_MONETARY="et_EE.UTF-8";
      LC_MESSAGES="et_EE.UTF-8";
      LC_PAPER="et_EE.UTF-8";
      LC_NAME="et_EE.UTF-8";
      LC_ADDRESS="et_EE.UTF-8";
      LC_TELEPHONE="et_EE.UTF-8";
      LC_MEASUREMENT="et_EE.UTF-8";
      LC_IDENTIFICATION="et_EE.UTF-8";
    };
  };

  # ~ users and environment

  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "input" "uinput" ];
    packages = [];
    shell = config.programs.fish.package;
  };

  services.getty.autologinUser = "alice";

  security.sudo.wheelNeedsPassword = false;

  services.gvfs.enable = true;

  environment.sessionVariables = {
    # source updated nixos variables on each shell init
    # merge with inherited path rather than override it
    __NIXOS_SET_ENVIRONMENT_DONE = "";
    PATH = ''''${PATH-}'';

    # allows using $PAGER as the pager for systemctl commands
    SYSTEMD_PAGERSECURE = "false";

    # i would prefer this not be set by NixOS at all, but the variable is there and if left
    # as is ("nano") or left empty then, say, zsh, even if launched as non-login shell,
    # would still set it to its NixOS value, which is undesirable
    EDITOR = "hx";
  };

  services.dbus.implementation = "broker";

  # ~ shells

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  programs.zsh.enable = true;

  users.defaultUserShell = config.programs.fish.package;

  environment.binsh = "${lib.getExe pkgs.dash}";

  # ~ fonts

  # won't bother making a derivation for every font I have,
  # so to install them all at once:
  # `ln -s fonts-dir ~/.local/share/fonts; fc-cache -v`

  fonts = {
    # WARN option search says this option is false by default but this is a lie
    enableDefaultPackages = false;

    # the default packages (from `fonts.enableDefaultPackages`) sans Noto Color Emoji.
    # some apps don't respect my fontconfig and use Noto instead of Apple.
    packages = [
      pkgs.nerd-fonts.symbols-only
      pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.gyre-fonts
      pkgs.liberation_ttf
      pkgs.unifont
      pkgs.apple-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Apple Color Emoji" ];
        serif = [];
        sansSerif = [];
        monospace = [];
      };
    };
  };

  # ~ programs

  environment.systemPackages = [
    pkgs.git-crypt
  ];

  services.locate = {
    enable = true;
    # all the default paths sans /nix/store
    prunePaths = [
      "/tmp"
      "/var/tmp"
      "/var/cache"
      "/var/lock"
      "/var/run"
      "/var/spool"
      "/nix/var/log/nix"
    ];
  };

  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  services.postgresql.enable = true;

  programs.nano.enable = false;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.preload.enable = true;

}

