{ config, pkgs, lib, ... }:

{
  # 1. Your standard VSCodium configuration (without the custom extension in the list)
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        jnoortheen.nix-ide
        eamodio.gitlens
        vscodevim.vim
        mvllow.rose-pine
        ravenothere.rose-pine-symbols
        theqtcompany.qt-qml
        # The official Lua extension from sumneko
        sumneko.lua
      ];
    };
  };

  # 2. Place the activation script here, right next to programs.vscodium
  home.activation = {
    installCaelestiaExtension = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Check if the extension is missing, and install it mutably if so
      if ! ${pkgs.vscodium}/bin/codium --list-extensions | grep -iq "soramanew.caelestia-vscode-integration"; then
        ${pkgs.vscodium}/bin/codium --install-extension ${./caelestia-vscode-integration-1.2.0.vsix} --force
      fi
    '';
  };
}