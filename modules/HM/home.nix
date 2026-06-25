# Providing things to do stuff with
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Who I am and what home manager needs to know about me
  home.username = "boing";
  home.homeDirectory = "/home/boing";

  # Safe default for state version (adjust to match your system setup)
  home.stateVersion = "26.05";

  # Force home-manager to scrub conflicting icons injected by external shell modules
  home.extraBuilderCommands = ''
    rm -rf $out/share/icons/Papirus-Light
  '';

  # Importing external modules and my own config files
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.spicetify-nix.homeManagerModules.default
    ./PackConfig.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      # Launches the core Caelestia compositor shell daemon natively
      exec-once = caelestia shell -d
    '';
  };

  # Symlinking caelestia dotfiles to make it feel like Arch
  xdg.configFile = {
    # Force Home Manager to drop its built-in files so they don't break your symlink boundary
    "hypr/.luarc.json".enable = false;
    "hypr/hyprland.lua".enable = false;
    "btop" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/btop";
      force = true;
    };
  };

  home.activation.clearStaleBackups = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
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
    prismlauncher
    hyprpicker
    pipes
    inotify-tools
    ncdu
    gsettings-desktop-schemas
  ];

  # User level environment variables
  home.sessionVariables = {
    EDITOR = "codium";
    QML_IMPORT_PATH = "/nix/store/h0agc7jqz21v9ci1yzd74390p58vfvh2-quickshell-0.3.0/lib/qt-6/qml:/nix/store/0x7jcnb8rls5v0jrl17ji5zj3w99wbp2-qtdeclarative-6.11.0/lib/qt-6/qml";
  };
}
