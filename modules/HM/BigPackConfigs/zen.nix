{ config, pkgs, ... }:

{
  # ====================================================
  # Zen Browser Configuration & Custom Stylesheets
  # ====================================================
  programs.zen-browser = {
    enable = true;
    profiles.default = {
      # Forces Home Manager to target your exact active profile directory
      path = "107y8mu2.Default Profile"; 
      
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      # Reads the file from your local flake directory safely
      userChrome = builtins.readFile ./userChrome.css; 
    };
  };

  # ====================================================
  # Declaratively Generate Caelestia Template
  # ====================================================
  xdg.configFile."caelestia/templates/zen-colors.css".text = ''
    :root {
      --c-accent: #{{ primary.hex }};
      --c-background: #{{ background.hex }};
      --c-surface: #{{ surface.hex }};
      --c-on-surface: #{{ onSurface.hex }};
      --c-secondary: #{{ secondary.hex }};
    }
  '';

  # ====================================================
  # Out-of-Store Symlink for Live Caelestia Colors
  # ====================================================
  # Quoting the attribute name safely handles the space in "Default Profile"
  home.file.".config/zen/107y8mu2.Default Profile/chrome/caelestia-colors.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/state/caelestia/theme/zen-colors.css";

  # ====================================================
  # Native Messaging Bridge for Caelestia Theme Sync
  # ====================================================
  home.file.".mozilla/native-messaging-hosts/caelestiafox.json".text = builtins.toJSON {
    name = "caelestiafox";
    description = "Caelestia native messaging host for browser theme syncing";
    path = "${./app.fish}"; 
    type = "stdio";
    allowed_extensions = [ "caelestiafox@caelestia.org" ];
  };
}