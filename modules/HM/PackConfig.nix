# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:


  # Pulling spicetify packages from the flake input for this system
  let
    spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
      # Define the logic here, at the top level of the file
    dir = ./LPackConfigs;
    getFiles = dir:
      map (file: dir + "/${file}")
        (lib.attrNames 
          (lib.filterAttrs (name: type: 
            type == "regular" && lib.hasSuffix ".nix" name
          ) (builtins.readDir dir)));
  in

  let

  in 
{
  imports = [
      getFiles dir
  ];

  # Caelestia shell and CLI - the main desktop environment
  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };

  # Neovim - keeping it lightweight without Ruby or Python
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
  };

  # Spicetify - Spotify client customization
  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spkgs.apps; [
      lyricsPlus        # Lyrics panel inside Spotify
    ];
    enabledExtensions = with spkgs.extensions; [
      adblockify        # Removes ads from the client
      fullAppDisplay    # Ambient fullscreen mode
      beautifulLyrics   # Glowing ambient lyrics
      popupLyrics       # Floating lyrics window
    ];
    theme = spkgs.themes.text;
    colorScheme = "Nord";
  };

  # Bulk enabling programs
  programs = {
    home-manager.enable = true;
    zen-browser.enable = true;
    git.enable = true;
  };
}