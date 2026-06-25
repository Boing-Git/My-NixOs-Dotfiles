{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

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
