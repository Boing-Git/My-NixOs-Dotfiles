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
      
      # FIX: Added these two so your defaultFonts actually work
      inter
      noto-fonts 
      
      # OPTIONAL: Drop in the open-source Google font here
      google-sans-flex 
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
          "Google Sans Flex" # Put this at the top to take priority
          "Inter"            # Will act as a fallback if a character is missing
          "Rubik"
        ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}