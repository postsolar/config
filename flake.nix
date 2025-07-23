{

  outputs = inputs:
    let

      flakeDir = "/data/nix";

      inherit (inputs.self) outputs;

      system = "x86_64-linux";

      hmConfig = {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit
            inputs
            outputs
            system
            flakeDir
            ;
        };
        home-manager.sharedModules = [
        ];
        home-manager.users.alice.imports =
          (builtins.attrValues outputs.homeManagerModules)
            ++
              [
                ./home-manager/home.nix
              ]
            ;
      };

    in

      {
        overlays = [
          (import ./overlays/lib.nix)
          (import ./overlays/packages.nix inputs)
        ];

        nixosModules = {
          # example = ./modules/nixos/example.nix
        };

        homeManagerModules = {
        };

        nixosConfigurations.nixos =
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit system inputs outputs flakeDir; };
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

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-ext = {
      url = "github:omentic/helix-ext";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprscroller = {
      url = "github:cpiber/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
    };

    apple-color-emoji = {
      url = "file+https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf";
      flake = false;
    };

    walker = {
      url = "github:abenz1267/walker";
    };

    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

}
