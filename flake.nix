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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-ext = {
      url = "github:omentic/helix-ext";
    };

    hyprland = {
      # one before 8f948827 Renderer: Implement new render scheduling (#10936) which breaks hyprscroller
      # url = "github:hyprwm/hyprland/9856563f8966856871a95f70757362f694ff22a6";
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
      # pin to hyprland bugfix pin
      # url = "github:cpiber/hyprscroller/a48716c9865af6b3dfb6fe3e642aba087fd669c1";
      url = "github:cpiber/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };

    ironbar = {
      url = "github:postsolar/ironbar/kb-icon-globs";
    };

    apple-color-emoji-src = {
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
