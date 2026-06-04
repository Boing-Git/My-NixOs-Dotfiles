# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:


  # Pulling spicetify packages from the flake input for this system
  let
    spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in
{
  imports = [
    ./BigPackConfigs/starship.nix
    ./BigPackConfigs/foot.nix
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

  programs.git = {
    enable = true;
    userName = "Boingly";
    userEmail = "BoingDoing@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    }
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
    colorScheme = "";
  };

  # Bulk enabling programs
  programs = {
    home-manager.enable = true;
    zen-browser.enable = true;
  };
}