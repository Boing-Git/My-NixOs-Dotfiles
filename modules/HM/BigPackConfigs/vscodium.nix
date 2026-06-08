{ config, pkgs, lib, ... }:

let
  # Absolute path to your local Caelestia extension directory
  caelestiaExtDir = /home/jivan/.local/share/caelestia/vscode/caelestia-vscode-integration;

  # Dynamically filters and targets the local .vsix file to safely replace the wildcard
  caelestiaVsix = let
    dirContents = builtins.readDir caelestiaExtDir;
    files       = builtins.attrNames dirContents;
    vsixFiles   = builtins.filter (lib.hasSuffix ".vsix") files;
  in if vsixFiles == []
     then throw "Declarative build error: No .vsix file discovered in ${caelestiaExtDir}"
     else caelestiaExtDir + "/${builtins.elemAt vsixFiles 0}";

  # Compiles the .vsix asset into a valid store-path derivation
  caelestia-vscode-integration = pkgs.vscode-utils.buildVscodeExtension {
    name      = "caelestia-vscode-integration";
    publisher = "caelestia";
    version   = "production"; 
    src       = caelestiaVsix;
  };
in
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    
    profiles.default = {
      # Combines overlay marketplace components with your local Caelestia build
      extensions = (with pkgs.vscode-marketplace; [
        jnoortheen.nix-ide
        eamodio.gitlens
        vscodevim.vim
        mvllow.rose-pine
        ravenothere.rose-pine-symbols
      ]) ++ [ 
        caelestia-vscode-integration 
      ];
          
      userSettings = {
        "workbench.colorTheme" = "Caelestia";
        "workbench.iconTheme" = "rose-pine-symbols";
        "workbench.statusBar.visible" = false;
        "workbench.menuBar.visible" = false;
        "window.menuBarVisibility" = "none"; # Keeps the file menu completely hidden on Linux
      };
    };
  };
}