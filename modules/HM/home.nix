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