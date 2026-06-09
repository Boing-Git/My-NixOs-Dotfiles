{ config, pkgs, lib, inputs, ... }:
{
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  home.stateVersion = "26.11"; 

  # Force home-manager to scrub conflicting icons injected by external shell modules
  home.extraBuilderCommands = ''
    rm -rf $out/share/icons/Papirus-Light
  '';

  imports = [
    inputs.zen-browser.homeModules.twilight
    # Raw input removed - now cleanly managed via caelestia-nix in flake.nix
    # inputs.caelestia-shell.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    ./PackConfig.nix
  ];

  # --- CAELESTIA FLAKE MODULE INTEGRATION ---
  # Switched namespace to programs.caelestia to stop the infinite recursion loop
  programs.caelestia = {
    enable = true;
    hypr.enable = true;        # Enables their Hyprland setup
    editor.vscode.enable = true; # Enables their VS Code / Vscodium adjustments
    btop.enable = true;        # Enables their btop theme
    
    # Explicitly disable anything else if you want to keep your setup minimal
    foot.enable = false;
  };

  # NOTE: Manual out-of-store symlinks for hypr and btop have been removed 
  # from xdg.configFile to prevent target collision errors with the flake module.
  xdg.configFile = {
    # Your other custom configurations can go here safely
  };

  home.activation.clearStaleBackups = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    $DRY_RUN_CMD rm -f $HOME/.config/gtk-3.0/gtk.css.hm-backup
    $DRY_RUN_CMD rm -f $HOME/.config/gtk-4.0/gtk.css.hm-backup
  '';

  home.pointerCursor = {
    name = "GoogleDot-Black";
    package = pkgs.google-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    fastfetch
    pavucontrol
    google-cursor
    dejavu_fonts
    matugen
    prismlauncher
    hyprpicker
    # Note: vscodium package management is now safely handed off to the programs.caelestia module
  ];

  home.sessionVariables = {
    EDITOR = "codium";
  };
}