# Providing things to do stuff with
{ config, pkgs, lib, inputs, ... }:
{
  # Who I am and what home manager needs to know about me
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  
  # 1. Update this to match your system generation release!
  home.stateVersion = "26.11"; 

  # Force home-manager to scrub conflicting icons injected by external shell modules
  home.extraBuilderCommands = ''
    rm -rf $out/share/icons/Papirus-Light
  '';

  # Importing external modules and my own config files
  imports = [
    inputs.zen-browser.homeModules.beta
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
    "btop" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/btop";
      force = true;
    };
  };

  home.activation.clearStaleBackups = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    $DRY_RUN_CMD rm -f $HOME/.config/gtk-3.0/gtk.css.hm-backup
    $DRY_RUN_CMD rm -f $HOME/.config/gtk-4.0/gtk.css.hm-backup
  '';

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
    pipes
    inotify-tools
    ncdu
  ];

  # User level environment variables
  home.sessionVariables = {
    EDITOR = "codium";
  };
}