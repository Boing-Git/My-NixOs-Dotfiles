{ config, pkgs, lib, inputs, ... }:
{
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  home.stateVersion = "26.11"; 

  home.extraBuilderCommands = ''
    rm -rf $out/share/icons/Papirus-Light
  '';

  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.spicetify-nix.homeManagerModules.default
    ./PackConfig.nix
  ];

  # --- CAELESTIA FLAKE MODULE INTEGRATION ---
  programs.caelestia = {
    enable = true;
    hypr.enable = true;          # Enables their Hyprland setup
    editor.vscode.enable = true; # Enables their VS Code / Vscodium adjustments
    btop.enable = true;          # Enables their btop theme
    foot.enable = false;         # Keep your terminal setup minimal
  };

  xdg.configFile = {
    # Custom configurations go here safely
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
  ];

  home.sessionVariables = {
    EDITOR = "codium";
  };
}