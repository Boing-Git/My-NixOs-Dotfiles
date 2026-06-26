{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    font = {
    name = "Rubik";
    size = 11; # Or 12, depending on scaling preference
  };

  # This forces Home Manager to generate the correct keys inside settings.ini
  gtk3.extraConfig = {
    gtk-xft-antialias = 1;
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
    gtk-xft-rgba = "rgb";
  };

  gtk4.extraConfig = {
    gtk-xft-antialias = 1;
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
    gtk-xft-rgba = "rgb";
  };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme; # FIXED: Added the actual package for icons
    };

    # Import the Matugen generated file seamlessly via CSS syntax
    # FIXED: Changed gtk-colors.css to gtkColors.css to match your Matugen output
    gtk3.extraCss = ''
      @import url("file://${config.xdg.configHome}/gtk-colors/gtkColors.css");
    '';

    gtk4.extraCss = ''
      @import url("file://${config.xdg.configHome}/gtk-colors/gtkColors.css");
    '';
  };
}
