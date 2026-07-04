{ config, pkgs, lib, inputs, ... }:

let
  spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
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
    colorScheme = "Nord";
  };
}
