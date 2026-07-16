{ config, pkgs, lib, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.space-mono
      material-symbols
      rubik
      roboto
      inter
      noto-fonts 
      
      # Added Google Sans Code for your terminal
      googlesans-code
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        sansSerif = [
          "Google Sans Flex"
          "Inter"
          "Rubik"
        ];
        monospace = [ 
          "Google Sans Code"         # Set as the primary terminal font
          "JetBrainsMono Nerd Font"  # Fallback for nerd font glyphs/icons
        ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}