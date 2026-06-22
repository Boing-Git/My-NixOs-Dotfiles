# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:


  # Pulling spicetify packages from the flake input for this system
  let
    spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in
{
  imports = [
    ./BigPackConfigs/terminal/foot.nix
     ./BigPackConfigs/UI-Frameworks/gtk.nix
     ./BigPackConfigs/UI-Frameworks/qt.nix
    # ./BigPackConfigs/terminal/fastfetch.nix
    ./BigPackConfigs/text-editor/vscodium.nix
    ./BigPackConfigs/text-editor/zed.nix
    ./BigPackConfigs/Matugen/Matugen.nix
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
    settings = {
      user = {
        name  = "Boingly";
        email = "BoingDoing@gmail.com";
      };
      # Flatten extraConfig: pull its contents directly into settings
      init.defaultBranch = "main";
    };
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
  programs = {
    home-manager.enable = true;
    zen-browser.enable = true;
  };
}