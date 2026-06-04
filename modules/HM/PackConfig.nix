# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:

# Pulling spicetify packages from the flake input for this system
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    ./LPackConfigs/starship.nix
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

  # Spicetify - Spotify client customization with Catppuccin Mocha
  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus        # Lyrics panel inside Spotify
    ];
    enabledExtensions = with spicePkgs.extensions; [
      adblockify        # Removes ads from the client
      fullAppDisplay    # Ambient fullscreen mode
      beautifulLyrics   # Glowing ambient lyrics
      popupLyrics       # Floating lyrics window
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  # Foot terminal - main terminal emulator with JetBrains Nerd Font
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "fish";
        title = "foot";
        font = "JetBrains Mono Nerd Font:size=12";
        letter-spacing = 0;
        dpi-aware = "no";
        pad = "25x25";
        bold-text-in-bright = "no";
        gamma-correct-blending = "no";
      };
      # How far back I can scroll in the terminal
      scrollback = {
        lines = 10000;
      };
      # Thin beam cursor instead of block
      cursor = {
        style = "beam";
        beam-thickness = "1.5";
      };
      # Terminal background transparency
      colors-dark = {
        alpha = "0.78";
      };
      # Scrollback and search shortcuts
      key-bindings = {
        scrollback-up-page = "Page_Up";
        scrollback-down-page = "Page_Down";
        search-start = "Control+Shift+f";
      };
      search-bindings = {
        cancel = "Escape";
        find-prev = "Shift+F3";
        find-next = "F3 Control+G";
      };
    };
  };

  # Enabling home-manager, kitty and zen browser
  programs.home-manager.enable = true;
  programs.kitty.enable = true;
  programs.zen-browser.enable = true;
}