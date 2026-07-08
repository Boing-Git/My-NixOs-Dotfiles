{ config, pkgs, lib, inputs, ... }:
{
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  home.stateVersion = "26.05";

  home.extraBuilderCommands = ''
    rm -rf $out/share/icons/Papirus-Light
  '';

  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.spicetify-nix.homeManagerModules.default
    ./ui/gtk.nix
    ./ui/qt.nix
    ./programs/vscodium.nix
    ./programs/zed.nix
    ./programs/git.nix
    ./programs/spicetify.nix
    ./programs/neovim.nix
    ./symlinks.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      # Launches the core Caelestia compositor shell daemon natively
      exec-once = caelestia shell -d
    '';
  };

  xdg.desktopEntries.antigravity-scaled = {
    name = "Google Antigravity (Scaled)";
    exec = "antigravity --force-device-scale-factor=2 %U";
    icon = "antigravity";
    categories = [
      "Development"
      "IDE"
  };

  xdg.configFile = {
    "hypr/.luarc.json".enable = false;
    "hypr/hyprland.lua".enable = false;
  };

  home.activation.clearStaleBackups = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
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

  home.sessionVariables = {
    EDITOR = "codium";
    QML_IMPORT_PATH = "/nix/store/h0agc7jqz21v9ci1yzd74390p58vfvh2-quickshell-0.3.0/lib/qt-6/qml:/nix/store/0x7jcnb8rls5v0jrl17ji5zj3w99wbp2-qtdeclarative-6.11.0/lib/qt-6/qml";
  };

  programs.home-manager.enable = true;
  programs.zen-browser.enable = true;
  programs.starship = {
    enable = true;
    enableFishIntegration = false;
  };

  
}
