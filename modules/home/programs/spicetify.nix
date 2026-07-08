{ config, pkgs, lib, inputs, ... }:

let
  spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  # Read matugen colors from the generated JSON file
  matugenColorsFile = "${config.home.homeDirectory}/.config/color-schemes/material-you/dark/vscode-colors.json";
  
  # Fallback colors in case the file doesn't exist yet (e.g. on a fresh install)
  fallbackColors = {
    color0 = "1e1e2e"; color1 = "cdd6f4"; color2 = "a6e3a1"; color3 = "f9e2af";
    color4 = "89b4fa"; color5 = "cba6f7"; color6 = "94e2d5"; color7 = "bac2de";
    color8 = "585b70"; color14 = "89dceb"; color15 = "cdd6f4";
  };

  # Parse the JSON if it exists, otherwise use fallback
  colors = if builtins.pathExists matugenColorsFile 
           then (builtins.fromJSON (builtins.readFile matugenColorsFile)).colors 
           else fallbackColors;

  # Helper to remove the '#' from hex codes, as Spicetify expects hex without '#'
  stripHex = color: lib.strings.removePrefix "#" color;
in
{
  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spkgs.apps; [
      lyricsPlus
    ];
    enabledExtensions = with spkgs.extensions; [
      adblockify
      fullAppDisplay
      beautifulLyrics
      popupLyrics
      spicyLyrics
    ];
    theme = spkgs.themes.text;
    colorScheme = "custom";

    customColorScheme = {
      text               = stripHex colors.color15;
      subtext            = stripHex colors.color7;
      main               = stripHex colors.color0;
      sidebar            = stripHex colors.color0;
      player             = stripHex colors.color0;
      card               = stripHex colors.color8;
      shadow             = stripHex colors.color0;
      selected-row       = stripHex colors.color8;
      button             = stripHex colors.color4;
      button-active      = stripHex colors.color4;
      button-disabled    = stripHex colors.color8;
      tab-active         = stripHex colors.color4;
      notification       = stripHex colors.color14;
      notification-error = "ff0000";
      misc               = stripHex colors.color8;
    };
  };
}
