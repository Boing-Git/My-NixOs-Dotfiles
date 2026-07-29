# Save as: ./flake.nix
{
  description = "My Original NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hexecute.url = "github:ThatOtherAndrew/Hexecute";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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

    matugen.url = "github:InioX/matugen";

    pixie-sddm.url = "github:xCaptaiN09/pixie-sddm";

  };

  outputs = inputs: {
    nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Passes inputs to system-level configuration.nix
      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/nixos/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Passes inputs into home.nix and submodules like matugen.nix
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";

          home-manager.users.boing = {
            imports = [
              ./modules/home/default.nix
            ];
          };
        }
      ];
    };
  };
}
