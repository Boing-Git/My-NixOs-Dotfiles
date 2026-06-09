{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add the caelestia-nix flake repository
    caelestia-nix.url = "github:Markus328/caelestia-nix";
  };

  outputs = inputs @ { nixpkgs, home-manager, caelestia-nix, ... }: {
    # Replace "your-hostname" with your actual system hostname
    nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.boing = { # Updated to your username
            imports = [
              ./modules/HM/home.nix # Fixed path to match your folder structure
              caelestia-nix.homeManagerModules.default # Inject the caelestia module
            ];
          };
        }
      ];
    };
  };
}