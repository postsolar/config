{ config, lib, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ../kanata.nix
  ];

  # ————— console -————————————————————————————————————————————————————————————

  # services.gpm.enable = true;

  services.kmscon = {
    enable = false;
    autologinUser = "me";
    hwRender = true;
    extraConfig =
      ''
      font-name=Ellograph CF, MonoLisa, JetBrainsMono
      '';
  };

  console = {
    colors =
      let
        colorsAll = config.home-manager.users.me.theme.colorsNoPrefix;
      in
        [ colorsAll.background ]
          ++ map (i: colorsAll."color${toString i}") (lib.lists.range 1 15);
    # font = "Lat2-Terminus16";
    # keyMap = "us";
  };

  # ————— wayland —————————————————————————————————————————————————————————————

  security.polkit.enable = true;

  # ————— pipewire ————————————————————————————————————————————————————————————

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ————— systemd-boot EFI boot loader ————————————————————————————————————————

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ————— networks ————————————————————————————————————————————————————————————

  networking.firewall.enable = false;
  networking.wireless.iwd.enable = true;

  # ————— localization ————————————————————————————————————————————————————————

  time.timeZone = "Europe/Tallinn";
  i18n.defaultLocale = "en_US.UTF-8";

  # ————— other hardware ——————————————————————————————————————————————————————

  services.libinput.enable = true;

  services.thermald.enable = true;

  # ————— users and environment ———————————————————————————————————————————————

  environment.sessionVariables = {
    # this is a lazy way to do it. it works because
    # user vars come after setting this dummy var to 1.
    __NIXOS_SET_ENVIRONMENT_DONE = "";

    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    PATH = [ "$HOME/.local/bin" ];
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

    # set to nano by default
    # TODO find out where
    # EDITOR = "";

    # allows using $PAGER as the pager for systemctl commands
    SYSTEMD_PAGERSECURE = "false";
  };

  users.users.me = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "input" "uinput" ];
    packages = [];
    shell = "${config.users.users.me.home}/.local/bin/fish";
  };

  services.getty.autologinUser = "me";

  security.sudo.wheelNeedsPassword = false;

  services.dotool.enable = true;
  services.dotool.users = [ "me" ];
  services.ydotool.enable = true;
  services.ydotool.users = [ "me" ];

  # ————— programs ————————————————————————————————————————————————————————————

  services.snap.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.fbset
    pkgs.nvd
  ];

  virtualisation.podman.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

  programs.nano.enable = false;

  # shells
  # programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.zsh.enable = true;

  # Fonts

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    pkgs.noto-fonts
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Apple Color Emoji" ];
      # serif = [];
      # sansSerif = [];
      # monospace = [];
    };
  };

  services.postgresql.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

}

