{ config, pkgs, lib, ... }:

let
  # ◄ Changed from an absolute string to a relative Nix path asset
  caelestiaVsix = ./caelestia-vscode-integration-1.2.0.vsix; 

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