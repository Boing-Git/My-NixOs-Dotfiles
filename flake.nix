{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1. Add the caelestia-nix flake repository
    caelestia-nix.url = "github:Markus328/caelestia-nix";
  };

  outputs = inputs @ { nixpkgs, home-manager, caelestia-nix, ... }: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # 1. Change this to your actual username
          home-manager.users.boing = {
            imports = [
              # 2. Point to the correct path in your modules folder
              ./modules/HM/home.nix
              caelestia-nix.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}