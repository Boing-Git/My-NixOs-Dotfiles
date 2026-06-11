{ config, pkgs, ... }:

{
  # ====================================================
  # Zen Browser Configuration & Custom Stylesheets
  # ====================================================
  programs.zen-browser = {
    enable = true;
    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      # Reads the file from your local flake directory safely
      # Note: Adjust this relative path if BigPackConfigs is in a different directory
      userChrome = builtins.readFile ./userChrome.css; 
    };
  };

  # ====================================================
  # Native Messaging Bridge for Caelestia Theme Sync
  # ====================================================
  home.file.".mozilla/native-messaging-hosts/caelestiafox.json".text = builtins.toJSON {
    name = "caelestiafox";
    description = "Caelestia native messaging host for browser theme syncing";
    path = "${config.home.homeDirectory}/.local/share/caelestia/zen/native_app/app.fish";
    type = "stdio";
    allowed_extensions = [ "caelestiafox@caelestia.org" ];
  };
}