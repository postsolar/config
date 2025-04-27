{

  outputs = inputs:
    let

      inherit (inputs.self) outputs;

      system = "x86_64-linux";

      hmConfig = {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs outputs system; };
        home-manager.sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];
        home-manager.users.alice.imports =
          (builtins.attrValues outputs.homeManagerModules)
            ++
              [
                ./home-manager/home.nix
                inputs.sops-nix.homeManagerModules.sops
              ]
            ;
      };

    in

      {
        overlays = [
          (import ./overlays/lib.nix)
          (import ./overlays/packages.nix inputs)
          inputs.niri-flake.overlays.niri
          inputs.hyprpicker.overlays.hyprpicker
        ];

        nixosModules = {
          dotool = ./modules/nixos/dotool.nix;
        };

        homeManagerModules = {
          fzf-window = ./modules/home-manager/fzf-window.nix;
          theme = ./modules/home-manager/theme.nix;
        };

        nixosConfigurations.nixos =
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit system inputs outputs; };
            modules =
              # my own nixos modules
              (builtins.attrValues outputs.nixosModules)
                ++
                [
                  # nix (the package manager) configuration
                  ./nix.nix

                  # overlays
                  (_: { nixpkgs.overlays = outputs.overlays; })

                  # system configuration
                  ./nixos/configuration.nix

                  # home manager
                  inputs.home-manager.nixosModules.home-manager
                  hmConfig

                  # sops-nix
                  inputs.sops-nix.nixosModules.sops
                  ./sops.nix
                ]
              ;
          };

        homeConfigurations.alice = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          extraSpecialArgs = hmConfig.home-manager.extraSpecialArgs;
          modules = hmConfig.home-manager.users.alice.imports;
        };

      };

  inputs = {

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-ext = {
      url = "github:omentic/helix-ext";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      # TODO: move to upstream if/when my PR #949 gets merged
      url = "github:postsolar/ironbar/kb-icon-globs";
      # put here temporarily to avoid narHashMismatch (idk why i'm getting it)
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-color-emoji-src = {
      url = "file+https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf";
      flake = false;
    };

    niri = {
      url = "github:YaLTeR/niri";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wl-kbptr = {
      url = "github:moverest/wl-kbptr";
      flake = false;
    };

    sherlock = {
      url = "github:Skxxtz/sherlock";
      # the tradeoff: we can use `follows` and it won't add yet another rust toolchain,
      # but will rebuild on every nixpkgs update
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

}
