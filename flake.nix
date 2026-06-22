{
  description = "My Original NixOS Configuration";

  inputs = {
    # Add Hexecute here
    hexecute.url = "github:ThatOtherAndrew/Hexecute";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add this missing input right here:
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add this exactly right here:
    matugen.url = "github:InioX/matugen";

  };

  outputs = inputs @ { nixpkgs, home-manager, nix-vscode-extensions,hexecute, ... }: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          # 2. Apply the overlay so pkgs.vscode-marketplace becomes available
          nixpkgs.overlays = [
            nix-vscode-extensions.overlays.default
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";
          
          home-manager.users.boing = {
            imports = [
              ./modules/HM/home.nix
            ];
          };
        }
      ];
    };
  };
}