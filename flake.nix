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
          
          # ADD THIS LINE RIGHT HERE:
          home-manager.extraSpecialArgs = { inherit inputs; };
          
          home-manager.users.boing = {
            imports = [
              ./modules/HM/home.nix
              caelestia-nix.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}