# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:
{
  # Who I am and what home manager needs to know about me
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  home.stateVersion = "24.05";
  # Force home-manager to scrub conflicting icons injected by external shell modules
  home.extraBuilderCommands = ''
    rm -rf $out/share/icons/Papirus-Light
  '';
  # ADD THIS LINE: It automatically renames conflicting files to filename.css.bak
  backupFileExtension = "bak"; 

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
      force = false;
    };
     "fastfetch" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/fastfetch/My-Fastfetch";
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

  # User level packages installed into my profile
  home.packages = with pkgs; [
    fastfetch
    pavucontrol
    vscodium
    google-cursor
    dejavu_fonts
    matugen
    prismlauncher
    hyprpicker
  ];

  # User level environment variables
  home.sessionVariables = {
    EDITOR = "codium";
  };
}