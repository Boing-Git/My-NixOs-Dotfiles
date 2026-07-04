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
          "Inter"
          "Rubik"
        ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
