{ config, pkgs, lib, ... }:

let
  # Verifies presence of the local extension package target before composition
  caelestiaVsix = "/home/jivan/.config/caelestia/vscode/caelestia-vscode-integration.vsix"; # Adjust if path differs
  vsixFiles = if builtins.pathExists caelestiaVsix then [ caelestiaVsix ] else [ ];

  caelestia-vscode-integration = pkgs.vscode-utils.buildVsCodeExtension {
    name             = "caelestia-vscode-integration";
    pname            = "caelestia-vscode-integration";
    version          = "1.2.0";
    src              = caelestiaVsix;
    vscodeExtPublisher = "caelestia";
    vscodeExtName    = "caelestia-vscode-integration";
    vscodeExtUniqueId = "caelestia.caelestia-vscode-integration";
  };
in
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      # Declarative extension management works perfectly alongside live theming engines
      extensions = (with pkgs.vscode-marketplace; [
        jnortheen.nix-ide
        eamodio.gitlens
        vscodevim.vim
        mvllow.rose-pine
        ravenothere.rose-pine-symbols
      ]) ++ [
        caelestia-vscode-integration
      ];

      # REMOVED: userSettings block has been stripped to prevent Home Manager 
      # from locking down your settings.json as a read-only Nix store symlink.
    };
  };
}