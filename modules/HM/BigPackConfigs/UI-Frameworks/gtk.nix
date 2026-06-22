{ config, pkgs, lib, ... }:


let
  customPapirusIcons = pkgs.papirus-icon-theme.override {
    color = "Brown"; 
  };
in

  {
    # ── GTK Theme Base ───────────────────────────────────────────────────────────
    gtk = {
      enable = true;

      theme = {
        name    = "adw-gtk3-dark";
        package = customPapirusIcons;
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

    # ── Required packages ────────────────────────────────────────────────────────
    home.packages = with pkgs; [
      adw-gtk3
      papirus-icon-theme
      gsettings-desktop-schemas   
    ];

    # ── Apply theme via gsettings at session start ────────────────────────────────
    wayland.windowManager.hyprland.settings.exec-once = [
      "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'"
      "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"
      "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
      "papirus-folders -c teal" 
    ];
  };
}