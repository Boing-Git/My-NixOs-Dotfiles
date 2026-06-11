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
      userChrome = builtins.readFile ./userChrome.css; 
    };
  };

  # ====================================================
  # Native Messaging Bridge for Caelestia Theme Sync
  # ====================================================
  home.file.".mozilla/native-messaging-hosts/caelestiafox.json".text = builtins.toJSON {
    name = "caelestiafox";
    description = "Caelestia native messaging host for browser theme syncing";
    
    # This wrapper injects dependencies and runs fish cleanly without config pollution
    path = "${pkgs.writeShellScript "caelestia-bridge-wrapper" ''
      export PATH="${pkgs.jq}/bin:${pkgs.inotify-tools}/bin:$PATH"
      exec ${pkgs.fish}/bin/fish --no-config ${config.home.homeDirectory}/.local/share/caelestia/zen/native_app/app.fish "$@"
    ''}";

    type = "stdio";
    allowed_extensions = [ "caelestiafox@caelestia.org" ];
  };
}