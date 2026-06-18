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
      # userChrome = builtins.readFile ./userChrome.css; 
    };
  };

  # ====================================================
  # Declaratively Generate Caelestia Template
  # ====================================================
  # xdg.configFile."caelestia/templates/zen-colors.css".text = ''
  #   :root {
  #     /* Main Structural Surfaces */
  #     --base: #{{ background.hex }};
  #     --mantle: #{{ surface.hex }};
  #     --crust: #{{ surfaceContainerLowest.hex }};

  #     /* Material-You Surface Containers & Brightness Scales */
  #     --surface0: #{{ surfaceContainerLow.hex }};
  #     --surface1: #{{ surfaceContainer.hex }};
  #     --surface2: #{{ surfaceContainerHigh.hex }};
  #     --surfaceDim: #{{ surfaceDim.hex }};
  #     --surfaceBright: #{{ surfaceBright.hex }};
  #     --surfaceContainer: #{{ surfaceContainer.hex }};
  #     --surfaceContainerHigh: #{{ surfaceContainerHigh.hex }};

  #     /* Typography & Hierarchy States */
  #     --text: #{{ onBackground.hex }};
  #     --subtext1: #{{ onSurfaceVariant.hex }};
  #     --subtext0: #{{ outline.hex }};
      
  #     /* Overlays & Intermediary Layering */
  #     --overlay2: #{{ surfaceVariant.hex }};
  #     --overlay1: #{{ surfaceContainerHighest.hex }};
  #     --overlay0: #{{ surfaceContainerHigh.hex }};

  #     /* Core Accents & Tonal Tethers */
  #     --primary: #{{ primary.hex }};
  #     --primaryDim: #{{ primaryContainer.hex }};
  #     --onPrimary: #{{ onPrimary.hex }};
  #     --primaryContainer: #{{ primaryContainer.hex }};
  #     --onPrimaryContainer: #{{ onPrimaryContainer.hex }};

  #     /* Secondary & Tertiary Accent Alternates */
  #     --secondary: #{{ secondary.hex }};
  #     --secondaryContainer: #{{ secondaryContainer.hex }};
  #     --tertiary: #{{ tertiary.hex }};
  #     --tertiaryContainer: #{{ tertiaryContainer.hex }};

  #     /* Clean Borders & Functional Outlines */
  #     --outlineVariant: #{{ outlineVariant.hex }};
  #     --outline: #{{ outline.hex }};

  #     /* Alert, Guardrails & Context States */
  #     --success: #{{ primary.hex }};
  #     --successContainer: #{{ primaryContainer.hex }};
  #     --error: #{{ error.hex }};
  #     --errorContainer: #{{ errorContainer.hex }};
  #     --onError: #{{ onError.hex }};

  #     /* Fine-Tone Accent Overrides (Dynamic Material-Catppuccin Hybrids) */
  #     --mauve: #{{ tertiary.hex }};
  #     --lavender: #{{ primaryContainer.hex }};
  #     --sapphire: #{{ primary.hex }};
  #     --blue: #{{ primary.hex }};
  #     --teal: #{{ secondary.hex }};
  #     --peach: #{{ secondaryContainer.hex }};
  #   }
  # '';

  # ====================================================
  # Out-of-Store Symlink for Live Caelestia Colors
  # ====================================================
  # Quoting the attribute name safely handles the space in "Default Profile"
  # home.file.".config/zen/107y8mu2.Default Profile/chrome/caelestia-colors.css".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/state/caelestia/theme/zen-colors.css";

  # ====================================================
  # Native Messaging Bridge for Caelestia Theme Sync
  # ====================================================
  # home.file.".mozilla/native-messaging-hosts/caelestiafox.json".text = builtins.toJSON {
  #   name = "caelestiafox";
  #   description = "Caelestia native messaging host for browser theme syncing";
  #   path = "${./app.fish}"; 
  #   type = "stdio";
  #   allowed_extensions = [ "caelestiafox@caelestia.org" ];
  # };
}