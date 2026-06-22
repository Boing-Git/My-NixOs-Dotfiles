{ config, pkgs, lib, ... }:

  {
    # ── GTK Theme Base ───────────────────────────────────────────────────────────
    gtk = {
      enable = true;

      theme = {
        name    = "adw-gtk3-dark";
        package = pkgs.papirus-icon-theme;
      };

      iconTheme = {
        name    = "Papirus-Dark";
      };
      # Import the Matugen generated file seamlessly via CSS syntax
      gtk3.extraCss = ''
        @import url("file://${config.xdg.configHome}/gtk-colors/gtk-colors.css");
      '';
      
      gtk4.extraCss = ''
        @import url("file://${config.xdg.configHome}/gtk-colors/gtk-colors.css");
      '';
  };
}