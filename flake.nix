{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The new repository module
    caelestia-nix.url = "github:Markus328/caelestia-nix";

    # --- RESTORED INPUTS ---
    # Putting back the inputs your home.nix depends on
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    caelestia-shell.url = "github:caelestia-dots/shell";
  };

  outputs = inputs @ { nixpkgs, home-manager, caelestia-nix, ... }: {
    # FIX 1: Changed placeholder to "nixos" to match your actual system hostname
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          # FIX 2: Explicitly pass inputs so home.nix can evaluate inputs.zen-browser, etc.
          home-manager.extraSpecialArgs = { inherit inputs; };
          
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
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