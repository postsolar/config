{ inputs, pkgs, lib, config, ... }:

# TODO override the nixos module so that it doesn't
# use `extraDefCfg` and relies solely on `config`

# another reason to replace the shipped systemd unit is that
# it writes the config file straight into nix store and doesn't
# link it anywhere, so it's impossible to inspect

let

  kanata = pkgs.rustPlatform.buildRustPackage {
    name = "kanata";
    src = inputs.kanata;
    cargoLock = { lockFile = "${inputs.kanata}/Cargo.lock"; };
    buildFeatures = [ "cmd" ];
    buildInputs = lib.optionals pkgs.stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.IOKit ];
    postInstall = ''
      install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
    '';
    meta.mainProgram = "kanata";
  };

  # This script maps XKB layouts managed by Hyprland to layers managed by Kanata
  kanata-hyprland-layout-switcher-daemon = pkgs.writeZshApplication {
    name = "kanata-hyprland-layout-switcher-daemon";
    text = builtins.readFile ./kanata/cycle-layouts.zsh;
    runtimeInputs = [ pkgs.fx pkgs.ripgrep ];
  };

in

{

  environment.systemPackages = [ kanata kanata-hyprland-layout-switcher-daemon ];

  # BUG needs manual environment importing and even then still doesn't work consistently
  # systemd.user.services.kanata-layout-switcher = {
  #   unitConfig = {
  #     Description = "Layout switcher for Kanata";
  #     After = [ "kanata-main.service" "hyprland-session.target" ];
  #   };
  #   serviceConfig = {
  #     Environment = [ "KANATA_PORT=${toString config.services.kanata.keyboards.main.port}" ];
  #     ExecStart = "${lib.getExe kanata-hyprland-layout-switcher}";
  #     Restart = "always";
  #     RestartSec = 10;
  #   };
  #   # wantedBy = [ "default.target" ];
  # };

  services.kanata = {
    enable = true;
    package = kanata;

    keyboards = {
      main = {
        # extraArgs = [];
        port = 4422;
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
        extraDefCfg =
          ''
          process-unmapped-keys         yes
          danger-enable-cmd             yes
          sequence-timeout              1000
          sequence-input-mode           hidden-delay-type
          sequence-backtrack-modcancel  yes
          log-layer-changes             no
          delegate-to-first-layer       yes
          movemouse-inherit-accel-state yes
          movemouse-smooth-diagonals    yes
          dynamic-macro-max-presses     1000
          '';
        config = builtins.readFile ./kanata/kanata.kbd;
      };
    };
  };

}

