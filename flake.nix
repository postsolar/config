{

  outputs = inputs:
    let
      system = "x86_64-linux";
      inherit (inputs.self) outputs;

      hmConf = {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs outputs system; };
        home-manager.users.me = import ./home-manager/home.nix;
      };

    in
      {
        overlays = map import [
          ./overlays/kmscon.nix
          ./overlays/zsh.nix
          ./overlays/lib.nix
          ./overlays/scripts.nix
          ./overlays/fd.nix
          ./overlays/flameshot.nix
        ] ++ [
          inputs.nixpkgs-wayland.overlay
          (import ./overlays/foot.nix { inherit inputs system; })
        ];

        nixosConfigurations = {
          nixos = inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs outputs; };
            modules = [
              # overlays
              (_: { nixpkgs.overlays = outputs.overlays; })
              # extra modules
              (./modules + "/(y)dotool.nix")
              # nix/system conf
              ./nix.nix
              ./nixos/configuration.nix
              # hm
              inputs.home-manager.nixosModules.home-manager
              hmConf
              # nix-snapd
              inputs.nix-snapd.nixosModules.default
            ];
          };
        };
      };

  inputs = {

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix = {
      url = "github:nixos/nix/master";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-snapd = {
      url = "github:io12/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hy3 = {
      url = "github:github-usr-name/hy3/feature/focus-by-keyboard";
      # url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
    };

    kakoune = {
      url = "github:postsolar/kakoune";
      flake = false;
    };

    kak-tabs = {
      url = "github:enricozb/tabs.kak";
      flake = false;
    };

    kak-ansi = {
      url = "github:eraserhd/kak-ansi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-completion-lsp = {
      url = "github:estin/simple-completion-language-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yaml-language-server = {
      url = "github:redhat-developer/yaml-language-server";
      flake = false;
    };

    foot-kkbprotocol-works = {
      url = "git+https://codeberg.org/dnkl/foot?rev=d3b348a5b183b0e6295dc985b1d5dcd939cb5c6e";
      flake = false;
    };

    kanata = {
      url = "github:jtroo/kanata";
      flake = false;
    };

  };

}
