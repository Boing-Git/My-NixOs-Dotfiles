# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:
{
  # Who I am and what home manager needs to know about me
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  home.stateVersion = "24.05";

  # Importing external modules and my own config files
  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.caelestia-shell.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    ./PackConfig.nix
  ];

  # Symlinking caelestia dotfiles to make it feel like Arch
  xdg.configFile = {
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/hypr";
      force = true;
    };
     "fastfetch" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/fastfetch";
      force = true;
    };
    "btop" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/btop";
      force = true;
    };
  };

  # Setting the user cursor globally for GTK and X11
  home.pointerCursor = {
    name = "GoogleDot-Black";
    package = pkgs.google-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # GTK theme, icons and cursor
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "GoogleDot-Black";
      package = pkgs.google-cursor;
    };
  };

  # User level packages installed into my profile
  home.packages = with pkgs; [
    fastfetch
    pavucontrol
    nemo
    vscodium
    google-cursor
    dejavu_fonts
    matugen
    prismlauncher
  ];

  # User level environment variables
  home.sessionVariables = {
    EDITOR = "codium";
  };
}