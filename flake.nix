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
          inputs.niri-flake.overlays.niri
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
      url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    };

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    nixpkgs-staging-next = {
      url = "github:nixos/nixpkgs?ref=55bbdb3e20cb34ee43984b9d39a0a8752d99332b";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # im-emoji-picker-fcitx = {
    #   url = "git+file:///home/alice/git/im-emoji-picker";
    # };

    helix-ext = {
      url = "github:omentic/helix-ext";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
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
      url = "github:nasirHo/hyprscroller";
      flake = false;
    };

    ironbar = {
      url = "github:postsolar/ironbar/personal";
      # put here temporarily to avoid narHashMismatch (idk why i'm getting it)
      # inputs.nixpkgs.follows = "nixpkgs";
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

    wl-kbptr = {
      url = "github:moverest/wl-kbptr";
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
