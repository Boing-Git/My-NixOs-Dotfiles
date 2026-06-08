{ config, pkgs, lib, ... }:

let
  # The exact, verified local path to your Caelestia extension asset
  caelestiaVsix = "/home/boing/.local/share/caelestia/vscode/caelestia-vscode-integration/caelestia-vscode-integration-1.2.0.vsix"; 
  vsixFiles = if builtins.pathExists caelestiaVsix then [ caelestiaVsix ] else [ ];

  caelestia-vscode-integration = pkgs.vscode-utils.buildVscodeExtension {
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
      extensions = (with pkgs.vscode-marketplace; [
        jnoortheen.nix-ide
        eamodio.gitlens
        vscodevim.vim
        mvllow.rose-pine
        ravenothere.rose-pine-symbols
      ]) ++ [
        caelestia-vscode-integration
      ];
    };
  };
}