{
  description = "Home Manager configuration for macOS";

  outputs = inputs:
    let
      flakeDir = "/Users/alan/nix";

      inherit (inputs.self) outputs;

      system = "aarch64-darwin";

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

          pkgs-master = inputs.nixpkgs-master.legacyPackages.${system};
        };
        home-manager.sharedModules = [];
        home-manager.users.alan.imports =
          (builtins.attrValues outputs.homeManagerModules)
            ++
              [
                ./home-manager/home.nix
              ]
            ;
      };

    in

      {
        overlays = {};

        homeManagerModules = {};

        homeConfigurations.alan = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          extraSpecialArgs = hmConfig.home-manager.extraSpecialArgs;
          modules = hmConfig.home-manager.users.alan.imports;
        };

        darwinConfigurations."Alans-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            pkgs-master = inputs.nixpkgs-master.legacyPackages.${system};
          };
          modules = [
            ./nix-darwin/configuration.nix
          ];
        };

      };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

}
