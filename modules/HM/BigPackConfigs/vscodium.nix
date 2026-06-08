{ config, pkgs, lib, ... }:

let
  # Target local extension package derivation
  caelestiaVsix = "/home/boing/.config/caelestia/vscode/caelestia-vscode-integration.vsix"; 
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
      extensions = (with pkgs.vscode-marketplace; [
        jnoortheen.nix-ide  # ◄ Fixed spelling typo here (added missing 'o')
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