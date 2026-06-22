{ config, pkgs, inputs, ... }: 
let
  # Create a TOML generator
  tomlFormat = pkgs.formats.toml { };
in {
  # 1. Remove the matugen module import and install the package directly
  home.packages = [ inputs.matugen.packages.${pkgs.system}.default ];

  # 2. Force Home Manager to write the config.toml where the CLI expects it
  xdg.configFile."matugen/config.toml".source = tomlFormat.generate "matugen-config" {
    config = {
      variant = "dark"; 
      json_format = "hex"; 
      reload_apps = true; 
    };

    templates = {
      foot = {
        # Using ${./path} copies the template to the Nix store and safely maps the absolute path to the TOML
        input_path = "${./Templates/footTheme.ini}";
        output_path = "${config.xdg.configHome}/foot/theme.ini";
        # Optional: If foot doesn't auto-reload, you can force it here:
        # post_cmd = "footclient -c ${config.xdg.configHome}/foot/foot.ini";
      };
      quickshell = {
        input_path = "${./Templates/quickshellColors.js}";
        output_path = "${config.xdg.configHome}/quickshell/Colors/colors.js";
      };
    };
  };
}